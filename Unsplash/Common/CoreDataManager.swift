//
//  CoreDataManager.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    // NSPersistentContainer : Core Data Stack을 나타내는 필요한 모든 객체
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.coreDataFileName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
        
    // NSManagedObjectContext : 생성, 저장, 가져오는 작업 제공
    private var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    // 지연 저장 속성을 사용하는 것이기 때문에 똑같이 지연 저장 속성을 사용하거나
    // 위처럼 계산 속성은 실제로 메서드 형태로 동작하기 때문에 위의 형태도 가능하다.
//    private lazy var context = self.persistentContainer.viewContext
        
    func fetchPhotoFromCoreData() -> [PhotoData] {
        let request = PhotoData.fetchRequest()
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
    
    func insertPhotoData(photo: Photo, completion: @escaping () -> Void) {
        let entity = NSEntityDescription.entity(forEntityName: Constants.coreDataEntityName, in: context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            
            managedObject.setValue(photo.id, forKey: "id")
            managedObject.setValue(photo.urls.regular, forKey: "url")
            managedObject.setValue(photo.user.name, forKey: "user")
            managedObject.setValue(photo.width, forKey: "width")
            managedObject.setValue(photo.height, forKey: "height")
            managedObject.setValue(Date(), forKey: "date")
            
            do {
                try context.save()
                completion()
            } catch {
                print(error.localizedDescription)
                completion()
            }
        } else {
            completion()
        }
    }
    
    func deletePhotoData(photo: Photo, completion: @escaping () -> Void) {
        let request = PhotoData.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", photo.id as CVarArg)
        
        do {
            let fetchResult = try context.fetch(request)
            
            if let targetPhotoData = fetchResult.first {
                context.delete(targetPhotoData)
                
                do {
                    try context.save()
                    completion()
                } catch {
                    print(error.localizedDescription)
                    completion()
                }
            } else {
                completion()
            }
        } catch {
            print(error.localizedDescription)
            completion()
        }
    }
    
    func isExistPhotoData(photo: Photo) -> Bool {
        let request = PhotoData.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", photo.id as CVarArg)
        
        do {
            let fetchResult = try context.fetch(request)
            
            if !fetchResult.isEmpty {
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
