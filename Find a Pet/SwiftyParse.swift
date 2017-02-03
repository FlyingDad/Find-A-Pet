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
    
    let petFinderCLient = PetFinderClient()
    
    func parseFoundPets(petsFound: [String: AnyObject], zipCode: String, coreDataStack: CoreDataStack) {
        
        let json = JSON(petsFound)
        let petsArray = json[PetFinderConstants.ResponseKeys.PetRecord]
        
        for (_, petData):(String, JSON) in petsArray {
            parseAndSavePet(json: petData, zipCode: zipCode,coreDataStack: coreDataStack)
        }
    }
    
    
    func parseAndSavePet(json: JSON, zipCode: String, coreDataStack: CoreDataStack) -> Void {
        
        DispatchQueue.main.async {
            
            // First lets check if the pet exists in core data (by pet id)
            // If it does, we'll skip to the next pet
            
            let petId = json[PetFinderConstants.ResponseKeys.Pet.Id][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            let fr = NSFetchRequest<NSManagedObject>(entityName: "Pet")
            let predicate = NSPredicate(format: "id = %@", petId)
            fr.predicate = predicate
            var savedPet = 0
            do {
                savedPet = try coreDataStack.managedContext.count(for: fr)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }

            if savedPet > 0 {
                return
            }
            // End of check for existing pet ------------------------
            
            let pet = NSEntityDescription.insertNewObject(forEntityName: "Pet", into: coreDataStack.managedContext) as! Pet
            pet.id = petId
            pet.zipCode = zipCode
            pet.name = json[PetFinderConstants.ResponseKeys.Pet.Name][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            pet.age = json[PetFinderConstants.ResponseKeys.Pet.Age][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            pet.animal = json[PetFinderConstants.ResponseKeys.Pet.Animal][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue.lowercased()
            pet.desc = json[PetFinderConstants.ResponseKeys.Pet.Desc][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            pet.id = json[PetFinderConstants.ResponseKeys.Pet.Id][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            pet.lastUpdate = json[PetFinderConstants.ResponseKeys.Pet.LastUpdate][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            pet.mix = json[PetFinderConstants.ResponseKeys.Pet.Mix][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            pet.sex = json[PetFinderConstants.ResponseKeys.Pet.Sex][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            pet.shelterId = json[PetFinderConstants.ResponseKeys.Pet.ShelterId][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            pet.shelterPetId = json[PetFinderConstants.ResponseKeys.Pet.ShelterPetId][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            pet.size = json[PetFinderConstants.ResponseKeys.Pet.Size][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            
            
            let photoArray = json[PetFinderConstants.ResponseKeys.Pet.Media][PetFinderConstants.ResponseKeys.Pet.Photos][PetFinderConstants.ResponseKeys.Photo.Photo]

            for (_, photoData):(String, JSON) in photoArray {

                if photoData[PetFinderConstants.ResponseKeys.Photo.size].string == PetFinderConstants.ResponseValues.Photo.sizeXL {
                    
                    let photo = NSEntityDescription.insertNewObject(forEntityName: "Photos", into: coreDataStack.managedContext) as! Photos
                    
                    photo.url = photoData[PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                    photo.pet = pet
                    
                    pet.addToPhotos(photo)
                    
                }
            }
            
            if let optionArray = json[PetFinderConstants.ResponseKeys.Pet.Options][PetFinderConstants.ResponseKeys.Option.Option].array {
                for option in optionArray {
                    let options = NSEntityDescription.insertNewObject(forEntityName: "Options", into: coreDataStack.managedContext) as! Options
                    options.option = option[PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                    pet.addToOptions(options)
                }
            } else if let optionsDict = json[PetFinderConstants.ResponseKeys.Pet.Options][PetFinderConstants.ResponseKeys.Option.Option].dictionary {
                let options = NSEntityDescription.insertNewObject(forEntityName: "Options", into: coreDataStack.managedContext) as! Options
                options.option = optionsDict[PetFinderConstants.ResponseKeys.General.MysteryT]?.stringValue
                pet.addToOptions(options)
            }
            
            
            // SwiftyJSON returns array if array of dict, or dict if only ONE dict in array
            if let breedsArray = json[PetFinderConstants.ResponseKeys.Pet.Breeds][PetFinderConstants.ResponseKeys.Breeds.Breed].array {
                
                for breed in breedsArray{
                    let breeds = NSEntityDescription.insertNewObject(forEntityName: "Breeds", into: coreDataStack.managedContext) as! Breeds
                    breeds.breed = breed[PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                    pet.addToBreeds(breeds)
                }
            } else if let breedsDict = json[PetFinderConstants.ResponseKeys.Pet.Breeds][PetFinderConstants.ResponseKeys.Breeds.Breed].dictionary {
                let breeds = NSEntityDescription.insertNewObject(forEntityName: "Breeds", into: coreDataStack.managedContext) as! Breeds
                breeds.breed = breedsDict[PetFinderConstants.ResponseKeys.General.MysteryT]?.stringValue
                pet.addToBreeds(breeds)
            }
            
            //Get and save shelter data for pet
            if let shelterId = pet.shelterId {
                self.petFinderCLient.getShelterInfo(shelterId: shelterId, completionHandlerForGetShelterInfo: {(shelterInfo, error) in
                    guard (error == nil) else {
                        print("Get Shelter Error: \(error?.localizedDescription)")
                        return
                    }
                    guard let shelterInfo = shelterInfo else {
                        print("No shelter data")
                        return
                    }
                    let shelterDict = JSON(shelterInfo)
                    DispatchQueue.main.async {
                        
                        let shelter = NSEntityDescription.insertNewObject(forEntityName: "Shelter", into: coreDataStack.managedContext) as! Shelter
                        
                        shelter.name = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Name][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                        shelter.phone = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Phone][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                        shelter.state = shelterDict[PetFinderConstants.ResponseKeys.Shelter.State][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                        shelter.address1 = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Address1][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                        shelter.address2 = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Address2][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                        shelter.email = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Email][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                        shelter.city = shelterDict[PetFinderConstants.ResponseKeys.Shelter.City][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                        shelter.zip = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Zip][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                        shelter.fax = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Fax][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
                        shelter.id = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Id][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue

                        pet.shelter = shelter
                    }
                })
                
            }
            
            coreDataStack.saveContext()
        }
        
    }
    
    func parseAndSaveShelter(shelter: [String:AnyObject], coreDataStack: CoreDataStack) -> Void {
        
        let shelterDict = JSON(shelter)
        
        DispatchQueue.main.async {
            
            let shelter = NSEntityDescription.insertNewObject(forEntityName: "Shelter", into: coreDataStack.managedContext) as! Shelter
            
            shelter.name = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Name][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            shelter.phone = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Phone][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            shelter.state = shelterDict[PetFinderConstants.ResponseKeys.Shelter.State][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            shelter.address1 = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Address1][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            shelter.address2 = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Address2][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            shelter.email = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Email][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            shelter.city = shelterDict[PetFinderConstants.ResponseKeys.Shelter.City][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            shelter.zip = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Zip][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            shelter.fax = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Fax][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            shelter.id = shelterDict[PetFinderConstants.ResponseKeys.Shelter.Id][PetFinderConstants.ResponseKeys.General.MysteryT].stringValue
            
            
            
        }
    }
}

