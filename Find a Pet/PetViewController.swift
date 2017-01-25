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
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var mix: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    
    var coreDataStack: CoreDataStack!
    var pet: Pet!

    let petFinderClient = PetFinderClient()
    let swiftyParse = SwiftyParse()

    override func viewDidLoad() {
        super.viewDidLoad()
        displayPet(pet: pet)
        let petImageTap = UITapGestureRecognizer(target: self, action: #selector(PetViewController.petImageTapped))
        petImage.addGestureRecognizer(petImageTap)
        petImage.isUserInteractionEnabled = true
    }
    
    func displayPet(pet: Pet) {
        
        age.text = pet.age
        //desc.text = pet.desc
        mix.text = pet.mix?.capitalized
        name.text = pet.name?.capitalized
        displayPetImage(pet: pet)
        if let sex = pet.sex {
            switch sex {
                case "M", "m":
                    self.sex.text = "Male"
                case "F", "f":
                    self.sex.text = "Female"
                default:
                    self.sex.text = sex
            }

        }
        if let size = pet.size {
            switch size {
            case "S", "s":
                self.size.text = "Small"
            case "M", "m":
                self.size.text = "Medium"
            case "L", "l":
                self.size.text = "Large"
            default:
                self.size.text = size
            }
        }
    }
    
    func displayPetImage(pet: Pet) {
        if let images = pet.photos?.allObjects as? [Photos] {
            print("PetView images count: \(images.count)")
            
            if let image = images.first {
                //print(image)
                if let image = image.imageData {
                    self.petImage.image = UIImage(data: image as Data)
                }
            }
        }
    }
    
    func petImageTapped(){
        let petImagesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PetImagesViewController") as! PetImagesViewController
        petImagesVC.coreDataStack = coreDataStack
        petImagesVC.pet = self.pet
        print("Segue for \(pet.name)")
        self.navigationController?.pushViewController(petImagesVC, animated: true)
    }
    
    @IBAction func showDetailedDescription(_ sender: Any) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedDescription") as! DescriptionViewController
        detailVC.petDescription = pet.desc
        print(pet.desc)
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

