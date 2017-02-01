//
//  PetFinderHelpers.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/10/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import CoreData

extension PetFinderClient {
        
    func parseFoundPets(petsFound: [String: AnyObject]) {
        //print(petsFound, petsFound.count)
        var pet: Pet!

        if let petsArray = petsFound[PetFinderConstants.ResponseKeys.PetRecord] as? [[String: AnyObject]] {
            print("Pets found: \(petsArray.count)")
            for eachPet in petsArray {
                pet = parsePet(petData: eachPet)
                //print(pet.name)
            }
        } else {
            print("needs work")
        }
        
    }
    
    func parsePet(petData: [String: AnyObject]) -> Pet {
        // Save to core data
        let petEntity = NSEntityDescription.entity(forEntityName: "Pet", in: managedContext)!
        let pet = Pet(entity: petEntity, insertInto: managedContext)

        if let ageDict = petData[PetFinderConstants.ResponseKeys.Pet.Age],
            let age = ageDict[PetFinderConstants.ResponseKeys.General.MysteryT] as? String {
            pet.age = age.capitalized
            //print(age)
        }
        if let animalDict = petData[PetFinderConstants.ResponseKeys.Pet.Animal],
            let animal = animalDict[PetFinderConstants.ResponseKeys.General.MysteryT] as? String {
            pet.animal = animal.capitalized
            //print(desc)
        }
        if let descDict = petData[PetFinderConstants.ResponseKeys.Pet.Desc],
            let desc = descDict[PetFinderConstants.ResponseKeys.General.MysteryT] as? String {
            pet.desc = desc
            //print(desc)
        }
        if let idDict = petData[PetFinderConstants.ResponseKeys.Pet.Id],
            let id = idDict[PetFinderConstants.ResponseKeys.General.MysteryT] as? String {
            pet.id = id
            //print(id)
        }
        if let lastUpdateDict = petData[PetFinderConstants.ResponseKeys.Pet.LastUpdate],
            let lastUpdate = lastUpdateDict[PetFinderConstants.ResponseKeys.General.MysteryT] as? String {
            pet.lastUpdate = lastUpdate
            //print(lastUpdate)
        }
        if let mixDict = petData[PetFinderConstants.ResponseKeys.Pet.Mix],
            let mix = mixDict[PetFinderConstants.ResponseKeys.General.MysteryT] as? String {
            pet.mix = mix.capitalized
            //print(name)
        }
        if let nameDict = petData[PetFinderConstants.ResponseKeys.Pet.Name],
            let name = nameDict[PetFinderConstants.ResponseKeys.General.MysteryT] as? String {
            pet.name = name.capitalized
            //print(name)
        }
        if let sexDict = petData[PetFinderConstants.ResponseKeys.Pet.Sex],
            let sex = sexDict[PetFinderConstants.ResponseKeys.General.MysteryT] as? String {
            pet.sex = sex.capitalized
            //print(sex)
        }
        if let shelterIdDict = petData[PetFinderConstants.ResponseKeys.Pet.ShelterId],
            let shelterId = shelterIdDict[PetFinderConstants.ResponseKeys.General.MysteryT] as? String {
            pet.shelterId = shelterId
            //print(shelterId)
        }
        if let shelterPetIdDict = petData[PetFinderConstants.ResponseKeys.Pet.ShelterPetId],
            let shelterPetId = shelterPetIdDict[PetFinderConstants.ResponseKeys.General.MysteryT] as? String {
            pet.shelterPetId = shelterPetId
            //print(shelterPetId)
        }
        if let sizeDict = petData[PetFinderConstants.ResponseKeys.Pet.Size],
            let size = sizeDict[PetFinderConstants.ResponseKeys.General.MysteryT] as? String {
            pet.size = size.capitalized
            //print(size)
        }
        
        if let mediaDict = petData[PetFinderConstants.ResponseKeys.Pet.Media],
            let photos = mediaDict[PetFinderConstants.ResponseKeys.Pet.Photos] as? [String: AnyObject] {
               // print(photos)
            
            // Parse and save photos
            parsePhotos(photosData: photos, pet: pet)
        }
        
        // Save pet
//        DispatchQueue.main.async {
//            print("saving pet")
//            do {
//                try self.managedContext.save()
//            } catch let error as NSError {
//                print("Pet save error: \(error)")
//            }
//        }

        return pet
    }

    // Parse and save pet photos
    func parsePhotos(photosData: [String: AnyObject], pet: Pet) {

        let photoEntity = NSEntityDescription.entity(forEntityName: "Photo", in: managedContext)!
        let photo = Photos(entity: photoEntity, insertInto: managedContext)
        
        if let photoDict =  photosData[PetFinderConstants.ResponseKeys.Photo.Photo] as? [[String: AnyObject]] {
            
            for eachPhoto in photoDict {
                // Only get large photos
                if let size = eachPhoto[PetFinderConstants.ResponseKeys.Photo.size] as? String, size == PetFinderConstants.ResponseValues.Photo.sizeXL {
                    let url = eachPhoto[PetFinderConstants.ResponseKeys.General.MysteryT] as? String
                    //print(url)
                    photo.url = url
                    photo.pet = pet
                    // save photo
//                    DispatchQueue.main.async {
//                        print("saving pet photos")
//                        do {
//                            try self.managedContext.save()
//                        } catch let error as NSError {
//                            print("Photo save error: \(error)")
//                        }
//                    }
                }
            }
        }
    }
    
}
