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
        return NSFetchRequest<PhotoCoreDataEntity>(entityName: "PhotoCoreDataEntity")
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

extension PhotoCoreDataEntity {
    func toDomain() -> Photo {
        return Photo(
            identifier: UUID(),
            id: id ?? "",
            width: CGFloat(width),
            height: CGFloat(height),
            urls: URLs(regular: url ?? ""),
            user: User(name: userName ?? "")
        )
    }
}
