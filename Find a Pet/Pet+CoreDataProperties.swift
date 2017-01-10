//
//  Pet+CoreDataProperties.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/9/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import Foundation
import CoreData


extension Pet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pet> {
        return NSFetchRequest<Pet>(entityName: "Pet");
    }

    @NSManaged public var age: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: String?
    @NSManaged public var lastUpdate: String?
    @NSManaged public var mix: String?
    @NSManaged public var name: String?
    @NSManaged public var sex: String?
    @NSManaged public var shelterId: String?
    @NSManaged public var shelterPetId: String?
    @NSManaged public var size: String?
    @NSManaged public var animal: String?
    @NSManaged public var photo: NSSet?

}

// MARK: Generated accessors for photo
extension Pet {

    @objc(addPhotoObject:)
    @NSManaged public func addToPhoto(_ value: Photo)

    @objc(removePhotoObject:)
    @NSManaged public func removeFromPhoto(_ value: Photo)

    @objc(addPhoto:)
    @NSManaged public func addToPhoto(_ values: NSSet)

    @objc(removePhoto:)
    @NSManaged public func removeFromPhoto(_ values: NSSet)

}
