//
//  Options+CoreDataProperties.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/16/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import Foundation
import CoreData


extension Options {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Options> {
        return NSFetchRequest<Options>(entityName: "Options");
    }

    @NSManaged public var option: String?
    @NSManaged public var pet: Pet?

}
