//
//  PetPhotoPageViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 2/26/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit

class PetPhotoPageViewController: UIPageViewController {
    
    var petPhotos = [Photos]()
    var currentIndex : Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        

        if let viewController = viewPetImagesController(currentIndex ?? 0) {
            let viewControllers = [viewController]

            setViewControllers(viewControllers,
                               direction: .forward,
                               animated: false,
                               completion: nil)
        } else {
            print("VC ERROR in page controller")
        }
    }

    func viewPetImagesController(_ index: Int) -> ZoomPhotoViewController? {
        
        if let storyboard = storyboard, let page = storyboard.instantiateViewController(withIdentifier: "zoomPhotoViewController")
            as? ZoomPhotoViewController {
            page.photoName = "Photo " + String(currentIndex + 1)
            page.photo = petPhotos[index]
            page.photoIndex = index

            return page
        }
        return nil
    }
}

extension PetPhotoPageViewController: UIPageViewControllerDataSource {

    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? ZoomPhotoViewController {
            var index = viewController.photoIndex
            
            guard index != NSNotFound && index != 0 else { return nil }
            index = index! - 1
            return viewPetImagesController(index!)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? ZoomPhotoViewController {
            var index = viewController.photoIndex
            guard index != NSNotFound else { return nil }
            index = index! + 1
            guard index != petPhotos.count else {return nil}
            return viewPetImagesController(index!)
        }
        return nil
    }
    
    // MARK: UIPageControl
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return petPhotos.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex ?? 0
    }
    
}
