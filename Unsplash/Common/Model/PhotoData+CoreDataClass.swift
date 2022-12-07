//
//  PhotoData+CoreDataClass.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//
//

import Foundation
import CoreData

@objc(PhotoData)
public class PhotoData: NSManagedObject {

}

extension PhotoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoData> {
        return NSFetchRequest<PhotoData>(entityName: Constants.coreDataEntityName)
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var url: String?
    @NSManaged public var width: Float
    @NSManaged public var height: Float
    @NSManaged public var user: String?

}

extension PhotoData : Identifiable {

}
