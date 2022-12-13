//
//  DefaultPhotoCoreDataRepository.swift
//  Unsplash
//
//  Created by rae on 2022/12/13.
//

import Foundation
import CoreData

final class DefaultPhotoCoreDataRepository {
    private let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Unsplash")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    private func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    private func getEntity(id: String) async throws -> PhotoCoreDataEntity? {
        let request = PhotoCoreDataEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id)
        
        let photoCoreDataEntity = try container.viewContext.fetch(request).first
        return photoCoreDataEntity
    }
}

extension DefaultPhotoCoreDataRepository: PhotoCoreDataRepository {
    func fetchAll() async throws -> [Photo] {
        let request = PhotoCoreDataEntity.fetchRequest()
        let dateOrder = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateOrder]
        
        return try container.viewContext.fetch(request).map { $0.toDomain() }
    }
    
    func create(photo: Photo) async throws {
        guard try await isExist(id: photo.id) == false else {
            return
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "PhotoCoreDataEntity", in: container.viewContext) else {
            return
        }
        
        let object = NSManagedObject(entity: entity, insertInto: container.viewContext)
        object.setValue(photo.id, forKey: "id")
        object.setValue(photo.urls.regular, forKey: "url")
        object.setValue(photo.user.name, forKey: "userName")
        object.setValue(photo.width, forKey: "width")
        object.setValue(photo.height, forKey: "height")
        object.setValue(Date(), forKey: "date")
        
        saveContext()
    }
    
    func delete(id: String) async throws {
        if let photoCoreDataEntity = try await getEntity(id: id) {
            container.viewContext.delete(photoCoreDataEntity)
            
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func isExist(id: String) async throws -> Bool {
        return try await getEntity(id: id) == nil ? false : true
    }
}
