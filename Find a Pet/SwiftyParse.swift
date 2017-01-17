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
    
    
    func parseFoundPets(petsFound: [String: AnyObject], coreDataStack: CoreDataStack) {
        
        let json = JSON(petsFound)
        let petsArray = json[PetFinderConstants.ResponseKeys.PetRecord]
        //print(petsArray)
        
        for (_, petData):(String, JSON) in petsArray {
            parseAndSavePet(json: petData, coreDataStack: coreDataStack)
        }
    }
    
    
    func parseAndSavePet(json: JSON, coreDataStack: CoreDataStack) -> Void {
        
        // Save to core data
        let petEntity = NSEntityDescription.entity(forEntityName: "Pet", in: coreDataStack.managedContext)!
        let pet = Pet(entity: petEntity, insertInto: coreDataStack.managedContext)
        
        //print(json)
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
//        print(pet.name!)
//        print(pet.age!)
//        print(pet.animal!)
//        print(pet.desc!)
//        print(pet.id!)
//        print(pet.lastUpdate!)
//        print(pet.mix!)
//        print(pet.sex!)
//        print(pet.shelterId!)
//        print(pet.shelterPetId!)
//        print(pet.size!)
//        print("Saving pet \(pet.name)")
        //parsePhotos(json: json, managedContext: managedContext, pet: pet)
        //parseOptions(json: json, managedContext: managedContext, pet: pet)
        //parseBreeds(json: json, managedContext: managedContext, pet: pet)
        
        //Save pet
        DispatchQueue.main.async {
            print("saving pet \(pet.name)")
            coreDataStack.saveContext()
        }
        
       //return pet
    }

    
    // Parse and save pet photos
    func parsePhotos(json: JSON, coreDataStack: CoreDataStack, pet: Pet) {
        
        let photoEntity = NSEntityDescription.entity(forEntityName: "Photos", in: coreDataStack.managedContext)!
        let photo = Photos(entity: photoEntity, insertInto: coreDataStack.managedContext)
        
        let photoArray = json[PetFinderConstants.ResponseKeys.Pet.Media][PetFinderConstants.ResponseKeys.Pet.Photos][PetFinderConstants.ResponseKeys.Photo.Photo]

        for (_, photoData):(String, JSON) in photoArray {
            //print(photo)
            if photoData[PetFinderConstants.ResponseKeys.Photo.size].string == PetFinderConstants.ResponseValues.Photo.sizeXL {
                print(photoData[PetFinderConstants.ResponseKeys.General.MysteryT])
                photo.url = photoData[PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                photo.pet = pet
                
            }
        }

//                    // save photo
//                    //                    DispatchQueue.main.async {
//                    //                        print("saving pet photos")
//                    //                        do {
//                    //                            try self.managedContext.save()
//                    //                        } catch let error as NSError {
//                    //                            print("Photo save error: \(error)")
//                    //                        }
//                    //                    }
//                }
//            }
//        }
    }

    // Parse and save pet options
    func parseOptions(json: JSON, coreDataStack: CoreDataStack, pet: Pet) {
        
        let optionsEntity = NSEntityDescription.entity(forEntityName: "Options", in: coreDataStack.managedContext)!
        let options = Options(entity: optionsEntity, insertInto: coreDataStack.managedContext)
        
        
        print("Processing options")
        if let optionArray = json[PetFinderConstants.ResponseKeys.Pet.Options][PetFinderConstants.ResponseKeys.Option.Option].array {
            for option in optionArray {
                options.option = option[PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                options.pet = pet
                print(options.option!)
            }
        } else if let optionsDict = json[PetFinderConstants.ResponseKeys.Pet.Options][PetFinderConstants.ResponseKeys.Option.Option].dictionary {
            options.option = optionsDict[PetFinderConstants.ResponseKeys.General.MysteryT]?.stringValue
            options.pet = pet
            print(options.option!)

        }

        //                    // save option
        //                    //                    DispatchQueue.main.async {
        //                    //                        print("saving pet photos")
        //                    //                        do {
        //                    //                            try self.managedContext.save()
        //                    //                        } catch let error as NSError {
        //                    //                            print("Photo save error: \(error)")
        //                    //                        }
        //                    //                    }
        //                }
        //            }
        //        }
    }

    // Parse and save pet breeds
    func parseBreeds(json: JSON, coreDataStack: CoreDataStack, pet: Pet) {
        
        let breedsEntity = NSEntityDescription.entity(forEntityName: "Breeds", in: coreDataStack.managedContext)!
        let breeds = Breeds(entity: breedsEntity, insertInto: coreDataStack.managedContext)
        print("Processing breeds")
        
        // SwiftyJSON returns array if array od dict, or dict if only ONE dict in array
        if let breedsArray = json[PetFinderConstants.ResponseKeys.Pet.Breeds][PetFinderConstants.ResponseKeys.Breeds.Breed].array {
            for breed in breedsArray{
                breeds.breed = breed[PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                breeds.pet = pet
                print(breeds.breed!)
            }
        } else
            if let breedsDict = json[PetFinderConstants.ResponseKeys.Pet.Breeds][PetFinderConstants.ResponseKeys.Breeds.Breed].dictionary {
            breeds.breed = breedsDict[PetFinderConstants.ResponseKeys.General.MysteryT]?.stringValue
            breeds.pet = pet
            print(breeds.breed!)
        }
        
        
        
//        if let breedsArray = json[PetFinderConstants.ResponseKeys.Pet.Breeds][PetFinderConstants.ResponseKeys.Breeds.Breed].array
//        {
//        print("Breeds count: \(breedsArray.count)")
//        print("Breeds Array: \(breedsArray)")
//        if breedsArray.count > 0 {
//            for (index, breedData):(String, JSON) in breedsArray {
//                breed.breed = breedData[PetFinderConstants.ResponseKeys.General.MysteryT].string
//                print("Breed: \(index): \(breed.breed)")
//                breed.pet = pet
//            }
//        }
        
        
        //                    // save option
        //                    //                    DispatchQueue.main.async {
        //                    //                        print("saving pet photos")
        //                    //                        do {
        //                    //                            try self.managedContext.save()
        //                    //                        } catch let error as NSError {
        //                    //                            print("Photo save error: \(error)")
        //                    //                        }
        //                    //                    }
        //                }
        //            }
        //        }
    
    }
    
}
