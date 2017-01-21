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
    }

    
    @IBAction func randomSearchPressed(_ sender: Any) {
        
        print("random search pressed")
    }
    
    @IBAction func searchByZip(_ sender: Any) {
        
        // need to delete all recoreds here for new search
        self.deleteAllPets()
        print("Search by zip pressed")
        let searchZip = zipCode.text
        if searchZip?.characters.count != 5 {
            print("Alert goes here")
        } else {
            print(zipCode.text!)
            petFinderClient.findPet(location: searchZip!, completionHandlerForFindPet: { (petsFound, error) in
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
                self.swiftyParse.parseFoundPets(petsFound: petsFound, zipCode: searchZip!, coreDataStack: self.coreDataStack)
            })
        }

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        vc.coreDataStack = coreDataStack
        vc.zipCode = searchZip
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func deleteAllPets () {
        // We will keep favorites
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pet")
        let predicate = NSPredicate(format: "favorite == NO")
        fetchRequest.predicate = predicate
        do {
            let fetchedEntities = try self.coreDataStack.managedContext.fetch(fetchRequest)
            
            for entity in fetchedEntities {
                self.coreDataStack.managedContext.delete(entity as! NSManagedObject)
            }
        } catch {
            print("Error deleting pets in search controller")
        }
        
        coreDataStack.saveContext()
    }
}
