//
//  LocationSettingViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-10-01.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationSettingViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    //MARK: Properties
    
    var placesClient: GMSPlacesClient?
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    var newAddress: String = ""
    
    //MARK: IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    let locationManager = CLLocationManager()
    
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        placesClient = GMSPlacesClient.shared()
        locationView.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
                }
            }
        })
    }
    
}
