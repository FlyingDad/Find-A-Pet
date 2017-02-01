//
//  Shelter+CoreDataProperties.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/27/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import Foundation
import CoreData


extension Shelter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shelter> {
        return NSFetchRequest<Shelter>(entityName: "Shelter");
    }

    @NSManaged public var name: String?
    @NSManaged public var state: String?
    @NSManaged public var city: String?
    @NSManaged public var email: String?
    @NSManaged public var zip: String?
    @NSManaged public var id: String?
    @NSManaged public var address1: String?
    @NSManaged public var address2: String?
    @NSManaged public var phone: String?
    @NSManaged public var fax: String?
    @NSManaged public var pet: Pet?

}
