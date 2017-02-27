//
//  PetImagesViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/24/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit
import CoreData

class PetImagesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var coreDataStack: CoreDataStack!
    var pet: Pet!
    var petPhotosArray = [Photos!]()
    var petfinderClient = PetFinderClient()
    var screenSize: CGRect!
    var photoIndex: Int!
    var photoName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPetImagesArray()

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petPhotosArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetImageCell", for: indexPath) as! PetImageCollectionViewCell
        cell.imageActivityIndicator.startAnimating()
        cell.petImage.image = nil
        
        let petImage = petPhotosArray[indexPath.row]!
        
        if let petImage = petImage.imageData {
            let image = UIImage(data: petImage as Data)
            DispatchQueue.main.async {
                cell.petImage.image = image
                cell.imageActivityIndicator.stopAnimating()
            }
        } else {
            petfinderClient.downloadPhoto(urlString: petImage.url!, completionHandlerForDownloadPhoto: { (imageData, error) in
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
            })
        }
    
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    
    func getPetImagesArray () {
        if let photosArray = pet.photos?.allObjects as? [Photos] {
            if photosArray.count == 0 {
                print("No photos")
            } else {
                for eachPhoto in photosArray {
                   petPhotosArray.append(eachPhoto)
                }
            }
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell, let indexPath = collectionView?.indexPath(for: cell), let petPhotoPageViewController = segue.destination as? PetPhotoPageViewController {
            print(indexPath.row)
            petPhotoPageViewController.currentIndex = indexPath.row
            //petPhotoPageViewController.coreDataStack = coreDataStack
            //petPhotoPageViewController.pet = pet
            petPhotoPageViewController.petPhotos = petPhotosArray
            //let petImage = petPhotosArray[indexPath.row]!
            //zoomedPhotoViewController.photo = UIImage(data:petImage.imageData! as Data)
        }
    }
    
    
}
