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
    var zipCode: String!
    let petFinderClient = PetFinderClient()
    let swiftyParse = SwiftyParse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refresh))
        
        title = "Search Results"
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pet")
        let predicate = NSPredicate(format: "zipCode = %@", zipCode)
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
        }
        
        let pet = fetchedResultsController!.object(at: indexPath) as! Pet
        
        // If there are any photos for this pet, get the first one to display in the cell
        if let photos = pet.photos?.allObjects as? [Photos] {

            if let petImage = photos.first {
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
                            cell.petImage.image = image
                            self.coreDataStack.saveContext()
                            cell.imageActivityIndicator.stopAnimating()
                            }
                        }
                    }
                }
            }
        }
        
        if let breeds = pet.breeds?.allObjects as? [Breeds] {
            for each in breeds{
                print(each.breed)
            }
        }

        if let options = pet.options?.allObjects as? [Options] {
            //print(options.count)
            for each in options{
                print("Options for \(pet.name): \(each.option)")
            }
            //print("Options for \(pet.name): \(options[0].option)")
        }
        
        cell.name.text = pet.name
        cell.animal.text = pet.animal
        cell.age.text = pet.age
        cell.sex.text = pet.sex
        //print("Cell \(pet.name)")
        return cell
    }
    
    func loadPetImages(petId: String){
        

        
    }
    func refresh() {
        tableView.reloadData()
    }

}
