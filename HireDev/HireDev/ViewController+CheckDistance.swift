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
    
    func fetchCLLocation(address: String, completionHandler: @escaping (_ location: CLLocation?, _ errorString: String?) -> Void){
        
        let geocoder: CLGeocoder = CLGeocoder()
        var setLocation: CLLocation = CLLocation()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let _ = error{
                NSLog((error?.localizedDescription)!)
                completionHandler(nil, error?.localizedDescription)
            }else{
                if let location = placemarks?[0].location{
                    NSLog("address: \(address), latitude \(location.coordinate.latitude)")
                    setLocation = location
                    completionHandler(setLocation, nil)
                }else{
                    completionHandler(setLocation, "no placemark found")
                }
            }
            NSLog("fetchcllocation")
        })
    }
    
    func checkDistance(origin: String, destination: String, completionHandler: @escaping ((_ distance: CLLocationDistance?, _ errorString: String?) -> Void)){
        
        var originLoc: CLLocation = CLLocation()
        var destLoc: CLLocation = CLLocation()
        var distanceMeters: CLLocationDistance = CLLocationDistance()
        
        self.fetchCLLocation(address: origin, completionHandler: { (originLocation, originError) in
            self.fetchCLLocation(address: destination, completionHandler: { (destLocation, destError) in
                
                if (originError != nil){
                    completionHandler(nil, originError)
                }else if (destError != nil){
                    completionHandler(nil, destError)
                }else{
                    originLoc = originLocation!
                    destLoc = destLocation!
                    
                    distanceMeters = originLoc.distance(from: destLoc)
                    NSLog("\(origin), \(destination): checkdistance got \(distanceMeters)")
                    completionHandler(distanceMeters, nil)
                }
            })
        })
    }
}

