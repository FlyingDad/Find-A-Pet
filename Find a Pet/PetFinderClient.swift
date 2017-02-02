//
//  PetFinderClient.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/6/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import Foundation
import CoreData

final class PetFinderClient {
    
    var managedContext: NSManagedObjectContext!
    
    // Find pet via location
    func findPet(location: String, animalType: String, completionHandlerForFindPet: @escaping (_ pet: [String: AnyObject]?, _ error: NSError?) -> Void) {
        
        let methodParameters = [
            PetFinderConstants.ParameterKeys.Key: PetFinderConstants.ParameterValues.ApiKey,
            PetFinderConstants.ParameterKeys.FindPet.Location: location,
            PetFinderConstants.ParameterKeys.Count: PetFinderConstants.ParameterValues.MaxCount,
            PetFinderConstants.ParameterKeys.Format: PetFinderConstants.ParameterValues.FormatJSON,
            PetFinderConstants.ParameterKeys.FindPet.Animal: animalType
        ]
        
        let urlString = PetFinderConstants.Url.APIBaseURL + PetFinderConstants.Method.FindPetByLocation
        getDataTask(urlString: urlString + escapedParameters(parameters: methodParameters)) { (data, error) in
            
            guard (error == nil) else {
                completionHandlerForFindPet(nil, NSError(domain: "findPet Data Task: \(error)", code: 0, userInfo: nil))
                return
            }
            
            self.getRequestStatusCode(data: data!) { (petFinderdata, error) in
                
                guard (error == nil) else {
                    completionHandlerForFindPet(nil, NSError(domain: "findPet status code: \(error)", code: 99, userInfo: nil))
                    return
                }
                
                // Get pet record in response
                guard let petsFound = petFinderdata?[PetFinderConstants.ResponseKeys.PetsFound] as? [String: AnyObject] else {
                    completionHandlerForFindPet(nil, NSError(domain: "findPet pet record: \(error)", code: 0, userInfo: nil))
                    return
                }
                
                completionHandlerForFindPet(petsFound, nil)
            }
        }
    }
    
    
//    func getPet(completionHandlerForGetPet: @escaping (_ pet: [String: AnyObject]?, _ error: NSError?) -> Void) {
//       
//        let methodParameters = [
//            PetFinderConstants.ParameterKeys.Key: PetFinderConstants.ParameterValues.ApiKey,
//            PetFinderConstants.ParameterKeys.Format: PetFinderConstants.ParameterValues.FormatJSON,
//            PetFinderConstants.ParameterKeys.Id: "33279898"
//        ]
//    
//        let urlString = PetFinderConstants.Url.APIBaseURL + PetFinderConstants.Method.GetSinglePet
//        getDataTask(urlString: urlString + escapedParameters(parameters: methodParameters)) { (data, error) in
//            guard (error == nil) else {
//                completionHandlerForGetPet(nil, NSError(domain: "getPet Data Task: /(error)", code: 0, userInfo: nil))
//                return
//            }
//
//            self.getRequestStatusCode(data: data!) { (petFinderdata, error) in
//                
//                guard (error == nil) else {
//                    completionHandlerForGetPet(nil, NSError(domain: "getPet status code error: /(error)", code: 99, userInfo: nil))
//                    return
//                }
//
//                // Get pet record in response
//                guard let pet = petFinderdata?[PetFinderConstants.ResponseKeys.PetRecord] as? [String: AnyObject] else {
//                    completionHandlerForGetPet(nil, NSError(domain: "getPet pet record error: /(error)", code: 0, userInfo: nil))
//                    return
//                }
//                
//            completionHandlerForGetPet(pet, nil)
//            }
//        }
//    }
    
    
    func getRequestStatusCode(data: AnyObject, completionHandler: (_ data: [String:AnyObject]?, _ error: NSError?) -> Void) {

        guard let petfinderData = data[PetFinderConstants.ResponseKeys.General.Petfinder] as? [String: AnyObject],
            let header = petfinderData[PetFinderConstants.ResponseKeys.General.Header] as? [String: AnyObject],
            let status = header[PetFinderConstants.ResponseKeys.General.Status] as? [String: AnyObject],
            let code = status[PetFinderConstants.ResponseKeys.General.Code] as? [String: AnyObject],
            let codeNumber = code[PetFinderConstants.ResponseKeys.General.MysteryT] as? String,
            codeNumber == PetFinderConstants.StatusCodes.NoError.rawValue else {
                return completionHandler(nil, NSError(domain: "Get Status Code", code: 0, userInfo: nil))
        }
        return completionHandler(petfinderData, nil)
    }
    
    
    // MARK: Data Task
    func getDataTask (urlString: String , completionHandlerForGetDataTask: @escaping (_ result: AnyObject? , _ error: NSError?) -> Void)
    {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        //Create Task
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandlerForGetDataTask(nil, error! as NSError)
                return
            }
            
            // parse the data
            let parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                completionHandlerForGetDataTask(nil, NSError(domain: "GetDataTask JSON Serialization", code: 0, userInfo: nil))
                return
            }
            completionHandlerForGetDataTask(parsedResult as AnyObject?, nil)
        }
        task.resume()
    }
    
    func getShelterInfo(shelterId: String, completionHandlerForGetShelterInfo: @escaping(_ shelter: [String: AnyObject]?, _ error: NSError?) -> Void) {
        let methodParameters = [
            PetFinderConstants.ParameterKeys.Key: PetFinderConstants.ParameterValues.ApiKey,
            PetFinderConstants.ParameterKeys.Format: PetFinderConstants.ParameterValues.FormatJSON,
            PetFinderConstants.ParameterKeys.Id: shelterId
        ]
        let urlString = PetFinderConstants.Url.APIBaseURL + PetFinderConstants.Method.GetShelterInfo
        getDataTask(urlString: urlString + escapedParameters(parameters: methodParameters)) { (data, error) in
            
            guard (error == nil) else {
                completionHandlerForGetShelterInfo(nil, NSError(domain: "getShelterInfo Data Task", code: 0, userInfo: nil))
                return
            }
            
            self.getRequestStatusCode(data: data!) { (petFinderdata, error) in
                
                guard (error == nil) else {
                    completionHandlerForGetShelterInfo(nil, NSError(domain: "getShelterInfo status code", code: 0, userInfo: nil))
                    return
                }
                
                // Get pet record in response
                guard let shelter = petFinderdata?[PetFinderConstants.ResponseKeys.Shelter.Shelter] as? [String: AnyObject] else {
                    completionHandlerForGetShelterInfo(nil, NSError(domain: "getShelterInfo shelter record", code: 0, userInfo: nil))
                    return
                }
                
                completionHandlerForGetShelterInfo(shelter, nil)
            }
        }
    }
    
    func downloadPhoto(urlString: String, completionHandlerForDownloadPhoto: @escaping(_ result: Data?, _ error: NSError?) -> Void) {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandlerForDownloadPhoto(nil, error! as NSError)
                return
            }
            completionHandlerForDownloadPhoto(data, nil)
        }
        task.resume()
        
    }


    
    private func escapedParameters(parameters: [String: Any]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            // Make sure value is a string
            for (key, value) in parameters {
                let stringValue = "\(value)"
                
                // Escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                
                // Append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
}
