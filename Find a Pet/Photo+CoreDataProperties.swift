//
//  Photo+CoreDataProperties.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/9/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var url: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var pet: Pet?

}
