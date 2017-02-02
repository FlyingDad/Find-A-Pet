//
//  SwiftyParse.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/15/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import Foundation
import CoreData

class SwiftyParse {
    
    
    func parseFoundPets(petsFound: [String: AnyObject], zipCode: String, coreDataStack: CoreDataStack) {
        
        let json = JSON(petsFound)
        let petsArray = json[PetFinderConstants.ResponseKeys.PetRecord]
        //print(petsArray)
        
        for (_, petData):(String, JSON) in petsArray {
            parseAndSavePet(json: petData, zipCode: zipCode,coreDataStack: coreDataStack)
        }
    }
    
    
    func parseAndSavePet(json: JSON, zipCode: String, coreDataStack: CoreDataStack) -> Void {
        
        // Save to core data
        DispatchQueue.main.async {

        let petEntity = NSEntityDescription.entity(forEntityName: "Pet", in: coreDataStack.managedContext)!
        let pet = Pet(entity: petEntity, insertInto: coreDataStack.managedContext)
        
        pet.zipCode = zipCode
        pet.name = json[PetFinderConstants.ResponseKeys.Pet.Name][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
        pet.age = json[PetFinderConstants.ResponseKeys.Pet.Age][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
        pet.animal = json[PetFinderConstants.ResponseKeys.Pet.Animal][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
        pet.desc = json[PetFinderConstants.ResponseKeys.Pet.Desc][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
        pet.id = json[PetFinderConstants.ResponseKeys.Pet.Id][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
        pet.lastUpdate = json[PetFinderConstants.ResponseKeys.Pet.LastUpdate][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
        pet.mix = json[PetFinderConstants.ResponseKeys.Pet.Mix][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
        pet.sex = json[PetFinderConstants.ResponseKeys.Pet.Sex][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
        pet.shelterId = json[PetFinderConstants.ResponseKeys.Pet.ShelterId][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
        pet.shelterPetId = json[PetFinderConstants.ResponseKeys.Pet.ShelterPetId][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
        pet.size = json[PetFinderConstants.ResponseKeys.Pet.Size][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue


        let photoArray = json[PetFinderConstants.ResponseKeys.Pet.Media][PetFinderConstants.ResponseKeys.Pet.Photos][PetFinderConstants.ResponseKeys.Photo.Photo]
        //print(photoArray)
        for (index, photoData):(String, JSON) in photoArray {
            //print("loop index: \(index)")
            if photoData[PetFinderConstants.ResponseKeys.Photo.size].string == PetFinderConstants.ResponseValues.Photo.sizeXL {
                //let photoEntity = NSEntityDescription.entity(forEntityName: "Photos", in: coreDataStack.managedContext)!
                let photo = NSEntityDescription.insertNewObject(forEntityName: "Photos", into: coreDataStack.managedContext) as! Photos

                //print(photoData[PetFinderConstants.ResponseKeys.General.MysteryT])
                photo.url = photoData[PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                //print(photo.url)
                photo.pet = pet

                pet.addToPhotos(photo)
                //print("saving pet photo for \(pet.name) index \(index)")
//                DispatchQueue.main.async {
//                    //print("saving pet photo for \(pet.name) index \(index)")
//                    //print(photo.url)
//                    coreDataStack.saveContext()
//                }
                
            }
        }

        if let optionArray = json[PetFinderConstants.ResponseKeys.Pet.Options][PetFinderConstants.ResponseKeys.Option.Option].array {
            for option in optionArray {
                let options = NSEntityDescription.insertNewObject(forEntityName: "Options", into: coreDataStack.managedContext) as! Options
                options.option = option[PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                //options.pet = pet
                //print(options.option!)
                pet.addToOptions(options)
            }
//            DispatchQueue.main.async {
//                //print("saving pet photo for \(pet.name) index \(index)")
//                //print(photo.url)
//                coreDataStack.saveContext()
//            }
        } else if let optionsDict = json[PetFinderConstants.ResponseKeys.Pet.Options][PetFinderConstants.ResponseKeys.Option.Option].dictionary {
            let options = NSEntityDescription.insertNewObject(forEntityName: "Options", into: coreDataStack.managedContext) as! Options
            options.option = optionsDict[PetFinderConstants.ResponseKeys.General.MysteryT]?.stringValue
            //options.pet = pet
            //print(options.option!)
            pet.addToOptions(options)
//            DispatchQueue.main.async {
//                //print("saving pet photo for \(pet.name) index \(index)")
//                //print(photo.url)
//                coreDataStack.saveContext()
//            }

        }
        

        
        // SwiftyJSON returns array if array od dict, or dict if only ONE dict in array
        if let breedsArray = json[PetFinderConstants.ResponseKeys.Pet.Breeds][PetFinderConstants.ResponseKeys.Breeds.Breed].array {
            let breeds = NSEntityDescription.insertNewObject(forEntityName: "Breeds", into: coreDataStack.managedContext) as! Breeds
            for breed in breedsArray{
                breeds.breed = breed[PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                breeds.pet = pet
                //print(breeds.breed!)
//                DispatchQueue.main.async {
//                    //print("saving pet photo for \(pet.name) index \(index)")
//                    //print(photo.url)
//                    coreDataStack.saveContext()
//                }

            }
        } else
            if let breedsDict = json[PetFinderConstants.ResponseKeys.Pet.Breeds][PetFinderConstants.ResponseKeys.Breeds.Breed].dictionary {
                let breeds = NSEntityDescription.insertNewObject(forEntityName: "Breeds", into: coreDataStack.managedContext) as! Breeds
            breeds.breed = breedsDict[PetFinderConstants.ResponseKeys.General.MysteryT]?.stringValue
            breeds.pet = pet
//                DispatchQueue.main.async {
//                    //print("saving pet photo for \(pet.name) index \(index)")
//                    //print(photo.url)
//                    coreDataStack.saveContext()
//                }

            //print(breeds.breed!)
        }
        coreDataStack.saveContext()
    }
    }
}
