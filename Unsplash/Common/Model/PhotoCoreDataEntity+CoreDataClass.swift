//
//  PhotoCoreDataEntity+CoreDataClass.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//
//

import Foundation
import CoreData

@objc(PhotoCoreDataEntity)
public class PhotoCoreDataEntity: NSManagedObject {

}

extension PhotoCoreDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoCoreDataEntity> {
        return NSFetchRequest<PhotoCoreDataEntity>(entityName: Constants.coreDataEntityName)
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var url: String?
    @NSManaged public var width: Float
    @NSManaged public var height: Float
    @NSManaged public var userName: String?

}

extension PhotoCoreDataEntity : Identifiable {

}
