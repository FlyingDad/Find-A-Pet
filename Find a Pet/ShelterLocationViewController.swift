//
//  ShelterLocationViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/27/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit

class ShelterLocationViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var zip: UILabel!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    
    var shelter: Shelter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = shelter.name?.capitalized
        address1.text = shelter.address1
        address2.text = shelter.address2
        location.text = makeLocation()
        zip.text = shelter.zip
        emailBtn.setTitle(shelter.email, for: .normal)
        
        if (shelter.phone?.characters.count)! > 0 {
            callBtn.setTitle(shelter.phone, for: .normal)
        } else {
            callBtn.setTitle("Phone # not provided", for: .normal)
        }
        

    }
    
    func makeLocation() -> String {
        
        let city = shelter?.city?.capitalized ?? ""
        let state = shelter?.state?.capitalized ?? ""
        return city + ", " + state
        
    }
    
    func makeFax() -> String {
        
        let fax = shelter.fax ?? "NA"
        return "Fax: " + fax
    }
    
    
    @IBAction func emailBtn(_ sender: Any) {
        emailShelter()
    }
    
    func emailShelter (){
        let email = shelter.email
        let emailString = "mailto:" + email!
        if let urlEMail = URL(string: emailString) {
            if UIApplication.shared.canOpenURL(urlEMail) {
                UIApplication.shared.open(urlEMail)
            }
        } else {
            print("Unable to open email app")
        }
    }

    @IBAction func callButton(_ sender: Any) {

        let phone = shelter.phone
        let trimmedPhone = phone?.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
        let phoneNumber = "telprompt://" + trimmedPhone!
        if let urlPhone = URL(string: phoneNumber) {
            if UIApplication.shared.canOpenURL(urlPhone){
                UIApplication.shared.open(urlPhone, options: [:], completionHandler: nil)
            }
        } else {
            print("Unable to open phone app with \(trimmedPhone ?? "number provided")")
        }
    }
    
    
    

}
