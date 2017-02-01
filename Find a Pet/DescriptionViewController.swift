//
//  DescriptionViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/25/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var detailedText: UILabel!
    
    var petDescription: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(petDescription)
        if petDescription == nil || petDescription == "" {
            detailedText.text = "No description provided"
        } else {
            detailedText.text = petDescription
        }
    }

}
