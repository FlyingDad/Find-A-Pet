//
//  Pet+CoreDataProperties.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/20/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import Foundation
import CoreData


extension Pet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pet> {
        return NSFetchRequest<Pet>(entityName: "Pet");
    }

    @NSManaged public var age: String?
    @NSManaged public var animal: String?
    @NSManaged public var desc: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var id: String?
    @NSManaged public var lastUpdate: String?
    @NSManaged public var mix: String?
    @NSManaged public var name: String?
    @NSManaged public var sex: String?
    @NSManaged public var shelterId: String?
    @NSManaged public var shelterPetId: String?
    @NSManaged public var size: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var breeds: NSSet?
    @NSManaged public var options: NSSet?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for breeds
extension Pet {

    @objc(addBreedsObject:)
    @NSManaged public func addToBreeds(_ value: Breeds)

    @objc(removeBreedsObject:)
    @NSManaged public func removeFromBreeds(_ value: Breeds)

    @objc(addBreeds:)
    @NSManaged public func addToBreeds(_ values: NSSet)

    @objc(removeBreeds:)
    @NSManaged public func removeFromBreeds(_ values: NSSet)

}

// MARK: Generated accessors for options
extension Pet {

    @objc(addOptionsObject:)
    @NSManaged public func addToOptions(_ value: Options)

    @objc(removeOptionsObject:)
    @NSManaged public func removeFromOptions(_ value: Options)

    @objc(addOptions:)
    @NSManaged public func addToOptions(_ values: NSSet)

    @objc(removeOptions:)
    @NSManaged public func removeFromOptions(_ values: NSSet)

}

// MARK: Generated accessors for photos
extension Pet {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photos)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photos)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
