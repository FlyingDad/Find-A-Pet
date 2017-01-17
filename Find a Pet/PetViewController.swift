//
//  PetViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/6/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit
import CoreData

class PetViewController: UIViewController {
    
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var animal: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var mix: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var size: UILabel!
    
    var managedContext: NSManagedObjectContext!
    var pet: Pet!
    //var coreDataHelpers = CoreDataHelpers()
    
    //let petStruct: PetStruct!
    let petFinderClient = PetFinderClient()
    let swiftyParse = SwiftyParse()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        petFinderClient.getPet { (pet, error) in
           // print(pet)
            guard (error == nil) else {
                print("Get Pet Error: \(error?.localizedDescription)")
                return
            }
            guard let petData = pet else {
                print("No pet data")
                return
            }
            //self.petFinderClient.managedContext = self.managedContext
            //self.pet = self.petFinderClient.parsePet(petData: pet)
            //self.parsePet(petData: pet)
            
//            self.pet = self.swiftyParse.parseAndSavePet(petData: petData, managedContext: self.managedContext)
//            DispatchQueue.main.async {
//                self.displayPet(pet: self.pet)
//            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayPet(pet: Pet) {
        
        age.text = pet.age
        animal.text = pet.animal
        desc.text = pet.desc
        mix.text = pet.mix
        name.text = pet.name
        sex.text = pet.sex
        size.text = pet.size
    }
}

