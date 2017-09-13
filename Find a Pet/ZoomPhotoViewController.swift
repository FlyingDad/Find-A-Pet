//
//  ZoomPhotoViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/26/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit

class ZoomPhotoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    // From page view controller
    var photoName: String!
    var photo: Photos!
    var photoIndex: Int!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.scrollView.maximumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        if let image = UIImage(data: photo.imageData! as Data) {
            imageView.image = image
        } else {
            //print("not getting image")
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
