//
//  PetFinderClient.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/6/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import Foundation

final class PetFinderClient {
    
    func getPetTest () {
       
        let methodParameters = [
            PetFinderConstants.ParameterKeys.Key: PetFinderConstants.ParameterValues.ApiKey,
            PetFinderConstants.ParameterKeys.Format: PetFinderConstants.ParameterValues.FormatJSON,
            PetFinderConstants.ParameterKeys.Id: "33279898"
        ]
    
        let urlString = PetFinderConstants.Url.APIBaseURL + PetFinderConstants.Method.GetSinglePet
        print(urlString + escapedParameters(parameters: methodParameters))
            //let urlString = "http://api.petfinder.com/pet.get?key=e6bc70bd191a1152df8fc462a3ecc179&id=33279898&format=json"
        getDataTask(urlString: urlString + escapedParameters(parameters: methodParameters)) { (data, error) in
            guard (error == nil) else {
                //completionHandlerForGetPhotoDataForLocationId(nil, NSError(domain: "Get Photo Data", code: 100, userInfo: nil))
                print("get pet error")
                return
            }
            //print(data)
            // Get status code of request. 100 is OK
            guard let petfinder = data?[PetFinderConstants.ResponseKeys.General.Petfinder] as? [String: AnyObject],
                let header = petfinder[PetFinderConstants.ResponseKeys.General.Header] as? [String: AnyObject],
                let status = header[PetFinderConstants.ResponseKeys.General.Status] as? [String: AnyObject],
                let code = status[PetFinderConstants.ResponseKeys.General.Code] as? [String: AnyObject],
                let codeNumber = code[PetFinderConstants.ResponseKeys.General.MysteryT] as? String,
                codeNumber == PetFinderConstants.StatusCodes.NoError.rawValue else {
                    print("Status error")
                return
            }
            // Get pet rocord in respisne
            guard let pet = petfinder[PetFinderConstants.ResponseKeys.PetRecord] as? [String: AnyObject] else {
                print("No pet")
                return
            }
            print(pet)
            
        }
        
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
