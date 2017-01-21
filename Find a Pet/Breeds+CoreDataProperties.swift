//
//  Breeds+CoreDataProperties.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/20/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import Foundation
import CoreData


extension Breeds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Breeds> {
        return NSFetchRequest<Breeds>(entityName: "Breeds");
    }

    @NSManaged public var breed: String?
    @NSManaged public var pet: Pet?

}
