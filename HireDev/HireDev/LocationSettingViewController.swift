//
//  LocationSettingViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-10-01.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationSettingViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    
    var placesClient: GMSPlacesClient?
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    var newAddress: String = ""
    var newLocationHistory: [String] = []
    
    //MARK: IBOutlets
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if newLocationHistory.count == 0{
            if let myLocationHistory = UserDefaults.standard.array(forKey: "locationHistory"){
                newLocationHistory = myLocationHistory as! [String]
            }
        }
        
        placesClient = GMSPlacesClient.shared()
        locationView.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if newLocationHistory.count == 0{
            if let myLocationHistory = UserDefaults.standard.array(forKey: "locationHistory"){
                newLocationHistory = myLocationHistory as! [String]
            }
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if newLocationHistory.count > 7 {
            newLocationHistory.removeFirst(newLocationHistory.count - 7)
            UserDefaults.standard.setValue(newLocationHistory, forKey: "locationHistory")
        }
        
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
    
    //MARK: IBActions
    
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
                    var addressArray: [String] = []
                    var fixedArray: [String] = []
                    
                    addressArray = (place.formattedAddress?.components(separatedBy: ", "))!
                    fixedArray.append(addressArray[0])
                    fixedArray.append(addressArray[1])
                    self.newAddress = fixedArray.joined(separator: ", ")
                    self.locationLabel.text = self.newAddress
                    
                    UserDefaults.standard.set(self.newAddress, forKey: "currentLocation")
                    
                    if (self.checkForSameData(array: self.newLocationHistory, string: self.newAddress)){
                        self.newLocationHistory.append(self.newAddress)
                    }
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
        
        var addressArray: [String] = []
        var fixedArray: [String] = []
        
        addressArray = (place.formattedAddress?.components(separatedBy: ", "))!
        fixedArray.append(addressArray[0])
        fixedArray.append(addressArray[1])
        self.newAddress = fixedArray.joined(separator: ", ")
        self.locationLabel.text = self.newAddress
        
        UserDefaults.standard.set(self.newAddress, forKey: "currentLocation")
        
        if (self.checkForSameData(array: self.newLocationHistory, string: self.newAddress)){
            self.newLocationHistory.append(self.newAddress)

        }
        
        self.dismiss(animated: true, completion: {
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
    
}
