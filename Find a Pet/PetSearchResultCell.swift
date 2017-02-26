//
//  PetSearchResultCell.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/17/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit

class PetSearchResultCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //petImage.layer.cornerRadius = 10
        //petImage.layer.masksToBounds = true

    }

}
