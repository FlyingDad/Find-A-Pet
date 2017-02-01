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
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var additionalPhotos: UILabel!
    @IBOutlet weak var breed: UILabel!
    @IBOutlet weak var locationBtn: UIButton!


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
        name.text = pet.name
        breed.text = getBreedsMix()
        displayPetImage(pet: pet)
        locationBtn.setTitle(makeLocation(), for: .normal)
        
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
            //print("PetView images count: \(images.count)")
            
            if let image = images.first {
                if let image = image.imageData {
                    self.petImage.image = UIImage(data: image as Data)
                }
                if images.count > 1 {
                    additionalPhotos.text = "(\(images.count) more images available. Tap for more)"
                } else {
                    additionalPhotos.text = ""
                }
            }
            
        }
    }
    
    func getBreedsMix() -> String {
        
        var breedMix = ""
        
        if let breeds = pet.breeds?.allObjects as? [Breeds] {
            //print(breeds)
            for eachBreed in 0...breeds.count - 1 {
                breedMix += (breeds[eachBreed].breed?.capitalized)!
                if eachBreed < breeds.count - 1 {
                    breedMix += " & "
                }
            }
        }
        return breedMix
    }
    
    func makeLocation() -> String {
        
        let city = pet.shelter?.city?.capitalized ?? ""
        let state = pet.shelter?.state?.capitalized ?? ""
        return city + ", " + state
        
    }
    
    func petImageTapped(){
        let petImagesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PetImagesViewController") as! PetImagesViewController
        petImagesVC.coreDataStack = coreDataStack
        petImagesVC.pet = self.pet
        //print("Segue for \(pet.name)")
        self.navigationController?.pushViewController(petImagesVC, animated: true)
    }
    
    @IBAction func showDetailedDescription(_ sender: Any) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedDescription") as! DescriptionViewController
        detailVC.petDescription = pet.desc
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    @IBAction func showShelterLocation(_ sender: Any) {
        
        let shelterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShelterLocation") as! ShelterLocationViewController
        shelterVC.shelter = pet.shelter
        self.navigationController?.pushViewController(shelterVC, animated: true
        )
    }
    
}

