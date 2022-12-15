//
//  DefaultPhotoCoreDataRepository.swift
//  Unsplash
//
//  Created by rae on 2022/12/13.
//

import Foundation
import CoreData

final class DefaultPhotoCoreDataRepository {
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    private func getEntity(id: String) -> PhotoEntity? {
        let request = PhotoEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            return try coreDataStorage.context.fetch(request).first
        } catch {
            return nil
        }
    }
}

extension DefaultPhotoCoreDataRepository: PhotoCoreDataRepository {
    func fetchAll() -> [Photo] {
        let request = PhotoEntity.fetchRequest()
        let dateOrder = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateOrder]
        
        do {
            return try coreDataStorage.context.fetch(request).map { $0.toDomain() }
        } catch {
            return []
        }
    }
    
    func create(photo: Photo) {
        guard isExist(id: photo.id) == false else {
            return
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "PhotoEntity", in: coreDataStorage.context) else {
            return
        }
        
        let object = NSManagedObject(entity: entity, insertInto: coreDataStorage.context)
        object.setValue(photo.id, forKey: "id")
        object.setValue(photo.urls.regular, forKey: "url")
        object.setValue(photo.user.name, forKey: "userName")
        object.setValue(photo.width, forKey: "width")
        object.setValue(photo.height, forKey: "height")
        object.setValue(Date(), forKey: "date")
        object.setValue(photo.links.html, forKey: "linkHtml")
        
        coreDataStorage.saveContext()
    }
    
    func delete(id: String) {
        if let photoEntity = getEntity(id: id) {
            coreDataStorage.context.delete(photoEntity)
            
            coreDataStorage.saveContext()
        }
    }
    
    func isExist(id: String) -> Bool {
        return getEntity(id: id) == nil ? false : true
    }
}
