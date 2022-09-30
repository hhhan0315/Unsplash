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
    
    func fetchPhotoCoreData(completion: (Result<[PhotoCoreData], Error>) -> Void) {
        let request = PhotoCoreData.fetchRequest()
        let dateOrder = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateOrder]
        
        do {
            let fetchResult = try context.fetch(request)
            completion(.success(fetchResult))
        } catch {
            completion(.failure(error))
        }
    }
    
    func savePhotoCoreData(photoCellViewModel: PhotoCellViewModel, completion: (Result<Bool, Error>) -> Void) {
        let entity = NSEntityDescription.entity(forEntityName: CoreDataConstants.entityName, in: context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(photoCellViewModel.id, forKey: "id")
            managedObject.setValue(photoCellViewModel.imageURL, forKey: "url")
            managedObject.setValue(photoCellViewModel.titleText, forKey: "user")
            managedObject.setValue(photoCellViewModel.imageWidth, forKey: "width")
            managedObject.setValue(photoCellViewModel.imageHeight, forKey: "height")
            managedObject.setValue(Date(), forKey: "date")
            
            do {
                try context.save()
                completion(.success(true))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func deletePhotoCoreData(photoCellViewModel: PhotoCellViewModel, completion: (Result<Bool, Error>) -> Void) {
        let id = photoCellViewModel.id
        
        let request = PhotoCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let fetchResult = try context.fetch(request)
            
            if let targetPhotoEntity = fetchResult.first {
                context.delete(targetPhotoEntity)
                
                do {
                    try context.save()
                    completion(.success(true))
                } catch {
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func isExistPhotoCoreData(id: String, completion: (Result<Bool, Error>) -> Void) {
        let request = PhotoCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let fetchResult = try context.fetch(request)
            
            if !fetchResult.isEmpty {
                completion(.success(true))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
