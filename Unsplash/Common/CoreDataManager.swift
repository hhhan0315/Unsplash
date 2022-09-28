//
//  CoreDataManager.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//

import Foundation
import CoreData

final class CoreDataManager {
    enum CoreDataConstants {
        static let containerName = "Unsplash"
        static let entityName = "PhotoCoreData"
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataConstants.containerName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetchPhotoEntity() -> [PhotoCoreData] {
        let request = PhotoCoreData.fetchRequest()
        let dateOrder = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateOrder]
        
        do {
            let fetchResult = try context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func savePhotoCoreData(photo: Photo) {
        let entity = NSEntityDescription.entity(forEntityName: CoreDataConstants.entityName, in: context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(photo.id, forKey: "id")
            managedObject.setValue(photo.url, forKey: "imageURL")
            managedObject.setValue(Date(), forKey: "date")
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deletePhotoCoreData(photo: Photo, completion: @escaping (Bool) -> Void) {
        let id = photo.id
        
        let request = PhotoCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let fetchResult = try context.fetch(request)
            
            if let targetPhotoEntity = fetchResult.first {
                context.delete(targetPhotoEntity)
                
                do {
                    try context.save()
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func isExistPhotoEntity(id: String, completion: @escaping (Bool) -> Void) {
        let request = PhotoCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let fetchResult = try context.fetch(request)
            
            if !fetchResult.isEmpty {
                completion(true)
            }
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
        
        completion(false)
    }
}
