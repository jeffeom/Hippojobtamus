//
//  ViewController+CheckDistance.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-10-04.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import CoreLocation

extension UIViewController{
    
    func fetchCLLocation(address: String, completionHandler: @escaping (_ address: CLLocation?, _ error: Error?) -> Void) {
        let geocoder: CLGeocoder = CLGeocoder()
        var setLocation: CLLocation = CLLocation()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let _ = error{
                NSLog((error?.localizedDescription)!)
            }else{
                if let location = placemarks?[0].location{
                    NSLog("address: \(address), latitude \(location.coordinate.latitude)")
                    setLocation = location
                    completionHandler(setLocation, error)
                }
            }
            NSLog("fetchcllocation")
        })
    }
    
    func checkDistance(origin: String, destination: String, completionHandler: @escaping (_ distance: CLLocationDistance?, _ error: Error?) -> Void){
        
        self.fetchCLLocation(address: origin, completionHandler: {(address, error) in
            if let _ = error{
                NSLog((error?.localizedDescription)!)
            }else{
                let originLoc = address
                
                self.fetchCLLocation(address: destination, completionHandler: {(address, error) in
                    
                    let destLoc = address
                    
                    let distanceMeters = originLoc?.distance(from: destLoc!)
                    completionHandler(distanceMeters, error)
                    NSLog("\(origin), \(destination): checkdistance got \(distanceMeters!)")
                })
            }
        })
    }
}

