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
    private let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "Unsplash")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        context = container.viewContext
    }
    
    private func getEntity(id: String) -> PhotoCoreDataEntity? {
        let request = PhotoCoreDataEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            return try context.fetch(request).first
        } catch {
            return nil
        }
    }
}

extension DefaultPhotoCoreDataRepository: PhotoCoreDataRepository {
    func fetchAll() -> [Photo] {
        let request = PhotoCoreDataEntity.fetchRequest()
        let dateOrder = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateOrder]
        
        do {
            return try context.fetch(request).map { $0.toDomain() }
        } catch {
            return []
        }
    }
    
    func create(photo: Photo) {
        guard isExist(id: photo.id) == false else {
            return
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "PhotoCoreDataEntity", in: context) else {
            return
        }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(photo.id, forKey: "id")
        object.setValue(photo.urls.regular, forKey: "url")
        object.setValue(photo.user.name, forKey: "userName")
        object.setValue(photo.width, forKey: "width")
        object.setValue(photo.height, forKey: "height")
        object.setValue(Date(), forKey: "date")
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func delete(id: String) {
        if let photoCoreDataEntity = getEntity(id: id) {
            context.delete(photoCoreDataEntity)
            
            do {
                try context.save()
            } catch {
                context.rollback()
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func isExist(id: String) -> Bool {
        return getEntity(id: id) == nil ? false : true
    }
}
