//
//  SearchResultsViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/17/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsViewController: CoreDataTableViewController {
    
    var coreDataStack: CoreDataStack!
    var animalType: String!
    var zipCode: String!
    let petFinderClient = PetFinderClient()
    let swiftyParse = SwiftyParse()
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.backgroundView = UIImageView(image: UIImage(named: "grassbg.png"))
        //tableview.estimatedRowHeight = 150
        //tableview.rowHeight = UITableViewAutomaticDimension
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        title = "Pets near zip " + zipCode
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pet")
        if animalType == "smallfurry" {
            animalType = "small & furry"
        }
        let predicate = NSPredicate(format: "animal = %@", animalType)
        fr.predicate = predicate
        fr.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fr,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetSearchResultCell
        
        DispatchQueue.main.async {
            cell.imageActivityIndicator.startAnimating()
            cell.petImage.image = nil
        }
        
        let pet = fetchedResultsController!.object(at: indexPath) as! Pet
        
        // If there are any photos for this pet, get the first one to display in the cell
        if let photos = pet.photos?.allObjects as? [Photos] {
            
            if photos.count == 0 {
                DispatchQueue.main.async {
                    cell.petImage.image = UIImage(named: "nophoto")
                    cell.imageActivityIndicator.stopAnimating()
                }
            }
            
            else if let petImage = photos.first {
                // If image is already saved, display it, else download and save
                if let petImage = petImage.imageData {
                    let image = UIImage(data: petImage as Data)
                
                    DispatchQueue.main.async {
                        cell.petImage.image = image
                        cell.imageActivityIndicator.stopAnimating()
                    }
            } else {
                if let url = petImage.url {
                    
                    petFinderClient.downloadPhoto(urlString: url) { (imageData, error) in
                        guard (error == nil) else {
                            print("Error downloading photo for cell: \(error!.localizedDescription)")
                            return
                        }
                        guard let image = UIImage(data: imageData!) else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            petImage.imageData = imageData as NSData?
                            self.coreDataStack.saveContext()
                            cell.petImage.image = image
                            cell.imageActivityIndicator.stopAnimating()
                            }
                        }
                    }
                }
            }
        }

        
        cell.name.text = pet.name
        let petAge = pet.age
        var petSex: String!
        if let sex = pet.sex {
            switch sex {
            case "M", "m":
                petSex = " Male"
            case "F", "f":
                petSex = " Female"
            case "U", "u":
                petSex = " Unknown"
            default:
                petSex = sex
            }
            
        }
        cell.age.text = petAge! + petSex

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PetView" {
            
            if let cellIndex = tableView.indexPathForSelectedRow, let pet = fetchedResultsController?.object(at: cellIndex) as? Pet, let petVC = segue.destination as? PetViewController {
                petVC.pet = pet
                petVC.coreDataStack = coreDataStack
            }
        }
    }
}
