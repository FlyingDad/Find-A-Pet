//
//  SearchViewController.swift
//  Find a Pet
//
//  Created by Michael Kroth on 1/10/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import SystemConfiguration

class SearchViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var animalViewPicker: UIPickerView!
    @IBOutlet weak var searchUsingLocation: searchByZipButton!
    @IBOutlet weak var searchActivity: UIActivityIndicatorView!

    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var searchContainerView: UIView!
    
    var animalTypePickerData = [String]()
    var animalTypeRawData = [String]()
    
    var coreDataStack: CoreDataStack!
    var pet: Pet!
    var animalType = "cat"
    var locationManager: CLLocationManager!
    var gpsZip: String!
    var usingGPS = false
    var zipCodeLastSearched: String!
    
    // Will be an Int corrosponding to the pickerviews last selection
    var animalTypeLastSearched: Int!
    
    let petFinderClient = PetFinderClient()
    let swiftyParse = SwiftyParse()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UIApplicationWillEnterForeground,
            object: nil)
    }
    
    func willEnterForeground() {
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToKeyboardNotofocations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zipCodeLastSearched = UserDefaults.standard.value(forKey: "zipCodeLastSearched") as! String!
        animalTypeLastSearched = UserDefaults.standard.integer(forKey: "animalTypeLastSearched")
        zipCode.text = zipCodeLastSearched
        
        // This will dismiss the keyboard if tap outside of zip code textfield
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.hideKeyboard))
        view.addGestureRecognizer(tap)
        
        if CLLocationManager.locationServicesEnabled() {
            //searchUsingLocation.isEnabled = true
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            searchUsingLocation.isEnabled = false
        }
        
        animalTypePickerData = ["Rabbit", "Small & Furry", "Dog", "Cat",  "Horse", "Bird", "Barnyard"]
        animalTypeRawData = ["rabbit", "smallfurry", "dog", "cat",  "horse", "bird", "barnyard"]
        animalViewPicker.selectRow(animalTypeLastSearched, inComponent: 0, animated: true)
        zipCode.delegate = self
    }
    
    @IBAction func searchUsingGps(_ sender: Any) {
        
        guard isInternetAvailable() else {
            self.alert(title: "No Internet Connection", message: "Please connect to the Internet and try again.", actionTitle: "Dismiss")
            return
        }
        
        if gpsZip != nil || gpsZip != "" && usingGPS {
            usingGPS = true
            if zipCodeLastSearched != gpsZip {
                zipCodeLastSearched = gpsZip
                searchForPets(usingZip: gpsZip, newZip: true)
            } else {
                searchForPets(usingZip: gpsZip, newZip: false)
            }
        } else {
            self.alert(title: "No Location Data", message: "Please verify location services are enabled and try again", actionTitle: "Dismiss")
        }
    }
    
    
    @IBAction func searchByZip(_ sender: Any) {
        
        guard isInternetAvailable() else {
            self.alert(title: "No Internet Connection", message: "Please connect to the Internet and try again.", actionTitle: "Dismiss")
            return
        }
        
        zipCode.resignFirstResponder()
        
        let searchZip = zipCode.text
        if searchZip?.characters.count != 5 {
            alert(title: "Invalid Zip Code", message: "Please enter a valid five digit zipcode", actionTitle: "Try Again")
            searchView.isHidden = false
            return
        }
        
        if zipCodeLastSearched != searchZip {
            zipCodeLastSearched = searchZip
            searchForPets(usingZip: searchZip!, newZip: true)
        } else {
            searchForPets(usingZip: searchZip!, newZip: false)
        }
    }
    
    
    func searchForPets(usingZip zip: String, newZip: Bool) {
        UserDefaults.standard.set(animalTypeLastSearched, forKey: "animalTypeLastSearched")
        UserDefaults.standard.set(zipCodeLastSearched, forKey: "zipCodeLastSearched")
        
//        if isInternetAvailable() {
            
            // need to delete all records if search is for different zipcode
            // also save new zip code in user defaults
            if newZip {
                //print("deleting all pets")
                self.deleteAllPets()
                
            }
            searchView.isHidden = true
            searchActivity.startAnimating()

                self.petFinderClient.findPet(location: zip, animalType: self.animalType, completionHandlerForFindPet: { (petsFound, error) in
                    guard (error == nil) else {
                        print("Get Pet Error: \(error!.code) : \(error!)")
                        
                        if error?.code == 99 {
                            self.alert(title: "No Results", message: "Verify a valid zip code was entered", actionTitle: "Dismiss")
                        }
                        DispatchQueue.main.async {
                            self.searchView.isHidden = false
                        }
                        
                        return
                    }
                    guard let petsFound = petsFound else {
                        print("No pet data")
                        return
                    }
            
                    self.swiftyParse.parseFoundPets(petsFound: petsFound, zipCode: zip, coreDataStack: self.coreDataStack)
                
                    DispatchQueue.main.async {
                      
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
                        vc.coreDataStack = self.coreDataStack
                        vc.animalType = self.animalType
                        vc.titleAnimal = self.animalTypePickerData[self.animalTypeLastSearched]
                        vc.zipCode = zip
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.searchView.isHidden = false
                        self.searchActivity.stopAnimating()
                    }
                })

    }
    

    func deleteAllPets () {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pet")

        do {
            let fetchedEntities = try self.coreDataStack.managedContext.fetch(fetchRequest)
            
            for entity in fetchedEntities {
                self.coreDataStack.managedContext.delete(entity as! NSManagedObject)
            }
            self.coreDataStack.saveContext()
        } catch {
            print("Error deleting pets in search controller")
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func subscribeToKeyboardNotofocations() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchByZip(textField)
        return true
    }
    
    // Shift view up when editing bottom text field so it's not hidden by the keyboard
    func keyboardWillShow(notification: NSNotification ) {
        if zipCode.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
    }
    
    // Reset the view after keyboard is dismissed
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return animalTypePickerData.count
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        animalType = animalTypeRawData[row]
        animalTypeLastSearched = row

    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        let data = animalTypePickerData[row]
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight), NSForegroundColorAttributeName: UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)])
        label!.attributedText = title
        
        label!.textAlignment = .center
        return label!
    }
    
    
    @IBAction func petfinderSite(_ sender: Any) {
        let url = URL(string: "https://www.petfinder.com")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationArray = locations as Array
        let currentLocation = locationArray.last! as CLLocation
        
        CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if error != nil {
                print("Reverse geocoder failed with error: \(error!)")
                self.searchUsingLocation.isEnabled = false
                return
            }
            
            if (placemarks?.count)! > 0 {
                self.searchUsingLocation.isEnabled = true
                let pm = (placemarks?[0])! as CLPlacemark
                self.gpsZip = pm.postalCode
            }
            else {
                print("Problem with the data received from geocoder")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating location: \(error)")
        searchUsingLocation.isEnabled = false
    }
    
    // http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}

// Alerts
extension SearchViewController {
    
    func alert(title: String, message: String, actionTitle: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
        }
    }
    
}

