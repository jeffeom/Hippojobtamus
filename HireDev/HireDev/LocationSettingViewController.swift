//
//  LocationSettingViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-10-01.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

class LocationSettingViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    
    var placesClient: GMSPlacesClient?
    
    var newAddress: String = ""
    var newLocationHistory: [String] = []
    let locationManager = CLLocationManager()
    let userRef: FIRDatabaseReference = FIRDatabase.database().reference(withPath: "users").child((UserDefaults.standard.string(forKey: "email")?.replacingOccurrences(of: ".", with: ""))!)
    
    //MARK: IBOutlets
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationSegmented: UISegmentedControl!
    
    @IBOutlet weak var lookUpAddressView: UIView!
    @IBOutlet weak var searchDistanceView: UIView!
    @IBOutlet weak var sliderDistance: UISlider!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userRef.observeSingleEvent(of: .value, with: { (snapshot) in

            self.newLocationHistory = snapshot.childSnapshot(forPath: "searchHistory").value! as! [String]
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
            self.newLocationHistory = [""]
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if newLocationHistory.count == 0{
            if let myLocationHistory = UserDefaults.standard.array(forKey: "locationHistory"){
                newLocationHistory = myLocationHistory as! [String]
            }
        }
        
        let theCase = UserDefaults.standard.integer(forKey: "distanceCase")
        var theDistance = UserDefaults.standard.integer(forKey: "searchDistance")
        
        if theCase != 0{
            sliderDistance.value = Float(theCase)
            
            let number = sliderDistance.value
            
            switch number {
            case 1:
                theDistance = 1
                
            case 2:
                theDistance = 5
                
            case 3:
                theDistance = 10
                
            case 4:
                theDistance = 20
                
            case 5:
                theDistance = 50
                
            default:
                theDistance = 10
            }
            
            UserDefaults.standard.set(theDistance, forKey: "searchDistance")
        }else{
            sliderDistance.value = 3
            UserDefaults.standard.set(10, forKey: "searchDistance")
        }
        
        placesClient = GMSPlacesClient.shared()
        locationView.isHidden = true
        
        self.searchDistanceView.isHidden = true
        self.lookUpAddressView.isHidden = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        let font = UIFont.boldSystemFont(ofSize: 18)
        nav?.titleTextAttributes = [NSFontAttributeName: font]
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        nav?.tintColor = UIColor.white
        
        if newLocationHistory.count == 0{
            if let myLocationHistory = UserDefaults.standard.array(forKey: "locationHistory"){
                newLocationHistory = myLocationHistory as! [String]
            }
        }
        
        let theCase = UserDefaults.standard.integer(forKey: "distanceCase")
        var theDistance = UserDefaults.standard.integer(forKey: "searchDistance")
        
        if theCase != 0{
            sliderDistance.value = Float(theCase)
            
            let number = sliderDistance.value
            
            switch number {
            case 1:
                theDistance = 1
                
            case 2:
                theDistance = 5
                
            case 3:
                theDistance = 10
                
            case 4:
                theDistance = 20
                
            case 5:
                theDistance = 50
                
            default:
                theDistance = 10
            }
            
            UserDefaults.standard.set(theDistance, forKey: "searchDistance")
        }else{
            sliderDistance.value = 3
            UserDefaults.standard.set(10, forKey: "searchDistance")
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if newLocationHistory.count > 7 {
            newLocationHistory.removeFirst(newLocationHistory.count - 7)
            UserDefaults.standard.setValue(newLocationHistory, forKey: "locationHistory")
        }else{
            UserDefaults.standard.setValue(newLocationHistory, forKey: "locationHistory")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return newLocationHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        
        cell.textLabel?.text = newLocationHistory[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let selectedCellAddress = cell.textLabel?.text
            UserDefaults.standard.set(selectedCellAddress, forKey: "currentLocation")
            UserDefaults.standard.set(selectedCellAddress, forKey: "fixedLocation")
            self.userRef.child("currentLocation").setValue(selectedCellAddress)
            
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }
    }
    
    //MARK: IBActions
    
    @IBAction func segmentedValueChanged(_ sender: AnyObject) {
        
        switch locationSegmented.selectedSegmentIndex {
        case 0:
            lookUpAddressView.isHidden = false
            searchDistanceView.isHidden = true
            
        case 1:
            lookUpAddressView.isHidden = true
            searchDistanceView.isHidden = false
            
        default:
            lookUpAddressView.isHidden = false
            searchDistanceView.isHidden = true
            
        }
        
    }
    
    @IBAction func sliderValueChanged(_ sender: AnyObject) {
        let step: Float = 1
        
        let roundedValue = round(sender.value / step) * step
        sender.setValue(roundedValue, animated: true)
        
        var distance: Int
        var theCase: Int
        
        let number = sliderDistance.value
        
        switch number {
        case 1:
            distance = 1
            theCase = 1
            
        case 2:
            distance = 5
            theCase = 2
            
        case 3:
            distance = 10
            theCase = 3
            
        case 4:
            distance = 20
            theCase = 4
            
        case 5:
            distance = 50
            theCase = 5
            
        default:
            distance = 10
            theCase = 3
        }
        
        UserDefaults.standard.setValue(distance, forKey: "searchDistance")
        UserDefaults.standard.setValue(theCase, forKey: "distanceCase")
        self.userRef.child("searchDistance").setValue(distance)
    }
    
    
    @IBAction func currentLocation(_ sender: AnyObject) {
        self.locationView.isHidden = false
        
        placesClient?.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            guard error == nil else {
                print("Current Place error: \(error!.localizedDescription)")
                return
            }
            
            if let placeLikelihoods = placeLikelihoods {
                let likelihood = placeLikelihoods.likelihoods.first?.place
                if let place = likelihood{
                    self.setLocationValues(place: place)
                    UserDefaults.standard.setValue(10, forKey: "searchDistance")
                    UserDefaults.standard.setValue(3, forKey: "distanceCase")
                    self.userRef.child("searchDistance").setValue(10)
                    self.userRef.child("currentLocation").setValue(place.formattedAddress)
                    
                    self.sliderDistance.value = 3

                    self.tableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func searchButton(_ sender: AnyObject) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    //MARK: Function
    
    func checkForSameData(array: [String], string: String) -> Bool{
        var boolValue: Bool = false
        
        if newLocationHistory.count == 0{
            newLocationHistory.append(string)
            boolValue = false
            
            return boolValue
        }else{
            for aSub in array{
                if string == aSub{
                    boolValue = false
                    return boolValue
                }else{
                    boolValue = true
                }
            }
        }
        return boolValue
    }
}

//MARK: Google Places extension

extension LocationSettingViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.setLocationValues(place: place)
        
        self.dismiss(animated: true, completion: {
            UserDefaults.standard.setValue(10, forKey: "searchDistance")
            UserDefaults.standard.setValue(3, forKey: "distanceCase")
            
            self.sliderDistance.value = 3
            
            self.locationView.isHidden = false
            self.tableView.reloadData()
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func setLocationValues(place: GMSPlace) {
        
        var addressArray: [String] = []
        var fixedArray: [String] = []
        
        addressArray = (place.formattedAddress?.components(separatedBy: ", "))!
        fixedArray.append(addressArray[0])
        if addressArray.count > 1{
            fixedArray.append(addressArray[1])
        }
        
        self.newAddress = addressArray.joined(separator: ", ")
        self.newAddress = self.newAddress.replacingOccurrences(of: "#", with: " ")
        self.locationLabel.text = fixedArray.joined(separator: ", ")
        
        UserDefaults.standard.set(self.newAddress, forKey: "currentLocation")
        UserDefaults.standard.set(fixedArray.joined(separator: ", "), forKey: "fixedLocation")
        UserDefaults.standard.setValue(10, forKey: "searchDistance")
        
        self.userRef.child("currentLocation").setValue(fixedArray.joined(separator: ", "))
        self.userRef.child("searchDistance").setValue(10)
        
        if (self.checkForSameData(array: self.newLocationHistory, string: fixedArray.joined(separator: ", "))){
            self.newLocationHistory.append(fixedArray.joined(separator: ", "))
            self.userRef.child("searchHistory").setValue(self.newLocationHistory)
        }
    }
}
