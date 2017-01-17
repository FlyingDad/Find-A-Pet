//
//  SearchViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/10/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit
import  CoreData

class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var randomSearchBtn: UIButton!
    @IBOutlet weak var zipCode: UITextField!
    
    var coreDataStack: CoreDataStack!
    var pet: Pet!
    
    let petFinderClient = PetFinderClient()
    let swiftyParse = SwiftyParse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        petFinderClient.findPet(location: "65738", completionHandlerForFindPet: { (petsFound, error) in
//            // print(pet)
//            guard (error == nil) else {
//                print("Get Pet Error: \(error?.localizedDescription)")
//                return
//            }
//            guard let petsFound = petsFound else {
//                print("No pet data")
//                return
//            }
//            //print(petsFound)
//            print("Found pets for 65738")
//            self.swiftyParse.parseFoundPets(petsFound: petsFound, managedContext: self.managedContext)
        
            //self.petFinderClient.managedContext = self.managedContext
            //self.petFinderClient.parseFoundPets(petsFound: petsFound)
       // })

    }

    
    @IBAction func randomSearchPressed(_ sender: Any) {
        
        print("random search pressed")
    }
    
    @IBAction func searchByZip(_ sender: Any) {
        print("Search by zip pressed")
        if zipCode.text?.characters.count != 5 {
            print("Alert goes here")
        } else {
            print(zipCode.text!)
            petFinderClient.findPet(location: zipCode.text!, completionHandlerForFindPet: { (petsFound, error) in
                guard (error == nil) else {
                    print("Get Pet Error: \(error?.localizedDescription)")
                    return
                }
                guard let petsFound = petsFound else {
                    print("No pet data")
                    return
                }
                //print(petsFound)
                print("Found pets for 65738")
                self.swiftyParse.parseFoundPets(petsFound: petsFound, coreDataStack: self.coreDataStack)
            })
        }

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsTableViewController
        vc.coreDataStack = coreDataStack
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
