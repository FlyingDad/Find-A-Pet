//
//  searchByZipButton.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/22/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit

class searchByZipButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }

}
