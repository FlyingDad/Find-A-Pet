//
//  PetImagesViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/24/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit
import CoreData

class PetImagesViewController: UICollectionViewController {
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 20.0, right: 10.0)
    let cellsPerRow: CGFloat = 3
    
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
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(10, 10, 10, 10)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        //print(collectionView.frame.width)
//        // set two images per row in collection view portrait mode
//        // 10 inset * 2 and 10 spacing = 30
//        let imageWidth = (collectionView.frame.width - 30)/2
//        //let sideSize = (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular) ? 190.0 : 128.0
//        return CGSize(width: imageWidth, height: imageWidth)
//    }
//    

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

// Code from https://www.raywenderlich.com/136159/uicollectionview-tutorial-getting-started

extension PetImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Calculate the cell width based on padding and screen size
        let paddingSpace = sectionInsets.left * (cellsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace - 1
        
        let widthPerCell = availableWidth / cellsPerRow
        
        // return square cell size
        return CGSize(width: widthPerCell, height: widthPerCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // return same spacing as padding inset
        return sectionInsets.left
    }
    
}
