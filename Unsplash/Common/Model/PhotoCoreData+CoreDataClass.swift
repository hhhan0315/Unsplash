//
//  PhotoCoreData+CoreDataClass.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//
//

import Foundation
import CoreData

@objc(PhotoCoreData)
public class PhotoCoreData: NSManagedObject {

}

extension PhotoCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoCoreData> {
        return NSFetchRequest<PhotoCoreData>(entityName: "PhotoCoreData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var imageURL: String?

}

extension PhotoCoreData : Identifiable {

}
