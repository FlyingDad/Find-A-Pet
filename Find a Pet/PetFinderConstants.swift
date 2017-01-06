//
//  PetFinderConstants.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/6/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import Foundation

struct PetFinderConstants {
    
    //Petfinder API text is case sensitive
    
    struct Url {
        static let APIBaseURL = "http://api.petfinder.com/"
    }
    
    struct Method {
        static let GetSinglePet = "pet.get"
        static let GetPetsAtShelter = "shelter.getPets"
        static let GetShelterInfo = "shelter.get"
        static let GetRandomPet = "pet.getRandom"
    }
    
    struct ParameterKeys {
        static let Key = "key"
        static let Format = "format"
        static let Id = "id"
        static let Count = "count"
    }
    
    struct ParameterValues {
        static let ApiKey = "e6bc70bd191a1152df8fc462a3ecc179"
        static let FormatJSON = "json"
        
        static let MaxCount = "25" // Adjust this later
    }
    
    struct ResponseKeys {
        
        struct General {
            static let Petfinder = "petfinder"
            static let Header = "header"
            static let Status = "status"
            static let Code = "code"
            static let MysteryT = "$t"
        }
        
        // Get Pet
        static let PetRecord = "pet"  // Top Object
        
        struct Pet {
            static let Age = "age"
            static let Breeds = "breed"  // Object can have multiple breeds
            static let Contact = "contact" // Object
            static let Description = "description"
            static let Id = "id"
            static let LastUpdate = "lastUpdate"
            static let Media = "media"  // Object of photo objects
            static let Mix = "mix"
            static let Name = "name"
            static let Options = "options" // Object can have multiple attributes
            static let Sex = "sex"
            static let ShelterId = "shelterId"
            static let ShelterPetId = "shelterPetId"
            static let Size = "size"
            static let Status = "status"
        }
    }
    
    struct ResponseValues {
        
        
    }
    
    enum StatusCodes: String {
        case NoError = "100"
        case InvalidRequest = "200"
        case RecordDoesNotExist = "201"
        case ALimitWasExceeded = "202"
        case InvalidGeographicalLocation = "203"
        case RequestUnauthorized = "300"
        case AuthenticationFailure = "301"
        case GenericInternalError = "999"
    }

}
