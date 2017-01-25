//
//  SearchViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/10/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var randomSearchBtn: UIButton!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var animalViewPicker: UIPickerView!
    
    var animalTypePickerData = [String]()
    var animalTypeRawData = [String]()
    
    var coreDataStack: CoreDataStack!
    var pet: Pet!
    var animalType = "cat"
    
    let petFinderClient = PetFinderClient()
    let swiftyParse = SwiftyParse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animalTypePickerData = ["Rabbit", "Small & Furry", "Dog", "Cat",  "Horse", "Bird", "Pig", "Barnyard"]
        animalTypeRawData = ["rabbit", "smallfurry", "dog", "cat",  "horse", "bird", "pig", "barnyard"]
        animalViewPicker.selectRow(3, inComponent: 0, animated: true)
        zipCode.delegate = self
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
            zipcodeAlert()
            zipCode.becomeFirstResponder()
            return
        } else {
            print(zipCode.text!)
            DispatchQueue.main.async {

                self.petFinderClient.findPet(location: searchZip!, animalType: self.animalType, completionHandlerForFindPet: { (petsFound, error) in
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
            self.coreDataStack.saveContext()
        } catch {
            print("Error deleting pets in search controller")
        }
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchByZip(textField)
        return true
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return animalTypePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return animalTypePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        animalType =  animalTypeRawData[row]

    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let itemString = animalTypePickerData[row]
        let item = NSAttributedString(string: itemString, attributes: [NSForegroundColorAttributeName: UIColor.white])
        return item
    }
    
    func zipcodeAlert() {
        let alert = UIAlertController(title: "Invalid Zipcode", message: "Please enter a valid five digit zipcode", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func petfinderSite(_ sender: Any) {
        let url = URL(string: "https://www.petfinder.com")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil
        )
    }
}
