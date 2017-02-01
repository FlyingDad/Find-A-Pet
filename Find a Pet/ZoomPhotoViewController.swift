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
    
    var photo: UIImage!
    
    override func viewDidLoad() {
        
        self.scrollView.maximumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        imageView.image = photo
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
