//
//  ViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/6/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let petFinderClient = PetFinderClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        petFinderClient.getPetTest()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

