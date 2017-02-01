//
//  PetImagesViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/24/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit
import CoreData

//private let reuseIdentifier = "PetImageCell"

class PetImagesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var coreDataStack: CoreDataStack!
    var pet: Pet!
    var petPhotosArray = [Photos!]()
    var petfinderClient = PetFinderClient()
    var screenSize: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("In PetImagesVC viewDidLoad")
        getPetImagesArray()
        //print(pet.name)
        
                // Register cell classes
        
//print(pet.name)
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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
    
//    func adjustFlowLayoutSpacing() {
//        screenSize = UIScreen.mainScreen().bounds
//        let spacing : CGFloat = 3.0
//        let leftRightInset: CGFloat = 3
//        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: leftRightInset, bottom: 20, right: leftRightInset)
//        flowLayout.itemSize = CGSize(width: (screenSize.width - (spacing * 3) - 6) / 3, height: (screenSize.width  - (spacing * 3)) / 3)
//        flowLayout.minimumInteritemSpacing = spacing
//        flowLayout.minimumLineSpacing = spacing
//    }
    
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
        if let cell = sender as? UICollectionViewCell, let indexPath = collectionView?.indexPath(for: cell), let zoomedPhotoViewController = segue.destination as? ZoomPhotoViewController {
            let petImage = petPhotosArray[indexPath.row]!
            zoomedPhotoViewController.photo = UIImage(data:petImage.imageData! as Data)
        }
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    



}
