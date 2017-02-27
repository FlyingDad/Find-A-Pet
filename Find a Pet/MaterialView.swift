//
//  MaterialView.swift
//  Dream Lister
//
//  Created by Michael Kroth on 2/3/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit


private var materialKey = false

extension UIView {

    @IBInspectable var materialDesign: Bool {
        get {
            return materialKey
        }
        set {
            materialKey = newValue
            
            if materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 4.0
                self.layer.shadowOpacity = 0.5
                self.layer.shadowRadius = 4.0
                self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
                self.layer.shadowColor = UIColor(red: 64/255, green: 0/255, blue: 128/255, alpha: 0.8).cgColor
            } else {
                self.layer.cornerRadius = 0.0
                self.layer.shadowOpacity = 0.0
                self.layer.shadowRadius = 0.0
                self.layer.shadowColor = nil
            }
        }        
    }
    
}
