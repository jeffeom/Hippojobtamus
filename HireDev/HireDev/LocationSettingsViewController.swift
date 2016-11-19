//
//  LocationSettingsViewController.swift
//  Hippo
//
//  Created by Jeff Eom on 2016-11-18.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationSettingsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, SearchBarViewControllerDelegate {

    //MARK: Properties
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var newAddress: String = ""
    var newLocationHistory: [String] = []
    var currentRegion = ""
    var fetchedLocationData: [String] = []
    
    //MARK: IBOutlets
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationSegmented: UISegmentedControl!
    
    @IBOutlet weak var lookUpAddressView: UIView!
    @IBOutlet weak var searchDistanceView: UIView!
    @IBOutlet weak var sliderDistance: UISlider!
    
    
    //MARK: ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    //MARK: SearchForPlace

    @IBAction func searchForAPlace(_ sender: Any) {
        
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "searchVC") as! SearchBarViewController
        searchVC.delegate = self
        
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
    //MARK: Protocol Func
    
    func acceptLocationData(data: AnyObject!) {
        self.fetchedLocationData = data as! [String]
        self.locationView.isHidden = false
        self.locationLabel.text = self.fetchedLocationData[0]
        
        checkThenAdd(string: self.fetchedLocationData[0])
    }
    
    //MARK: FetchCurrentLocation
    
    @IBAction func fetchCurrentLocation(_ sender: Any) {
        
        self.locationView.isHidden = false
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        currentLocation = locationManager.location!
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
            
            if error != nil{
                self.locationLabel.text = error.unsafelyUnwrapped.localizedDescription
                self.locationView.isHidden = false
            }else{
                let placeArray = placemarks! as [CLPlacemark]
                var placeMark: CLPlacemark!
                placeMark = placeArray[0]
                let fetchedLocationString: [String] = [placeMark.name!, placeMark.locality! + " " + placeMark.administrativeArea!, placeMark.country!]
                
                
                self.locationLabel.text = fetchedLocationString.joined(separator: ", ")
                
                self.checkThenAdd(string: fetchedLocationString.joined(separator: ", "))
            }
        })
    }
    
    //MARK: Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newLocationHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        
        cell.textLabel?.text = newLocationHistory[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = newLocationHistory[indexPath.row]
        
        checkThenAdd(string: selectedLocation)
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    //Mark: Slider
    
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
    }
    
    //MARK: Utility Function
    
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
    
    func checkThenAdd(string: String) {
        if (self.checkForSameData(array: self.newLocationHistory, string: string)){
            self.newLocationHistory.append(string)
        }
        
        UserDefaults.standard.set(string, forKey: "currentLocation")
        UserDefaults.standard.set(string, forKey: "fixedLocation")
        
        self.tableView.reloadData()
    }
}
