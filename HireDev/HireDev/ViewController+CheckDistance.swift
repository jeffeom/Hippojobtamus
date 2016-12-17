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
        var aLocation = CLLocation()
        let myGroup = DispatchGroup()
        
        myGroup.enter()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let _ = error{
                NSLog((error?.localizedDescription)!)
                completionHandler(nil, error?.localizedDescription)
            }else{
                if let location = placemarks?[0].location{
                    aLocation = location
                    NSLog("address: \(address), latitude \(location.coordinate.latitude)")
                    myGroup.leave()
                }else{
                    completionHandler(nil, "no placemark found")
                }
            }
        })
        
        myGroup.notify(queue: .main){
            completionHandler(aLocation, nil)
            NSLog("fetchcllocation")
        }
    }
    
    func checkDistance(origin: String, destination: String, completionHandler: @escaping ((_ distance: CLLocationDistance?, _ errorString: String?) -> Void)){
        var theDistance: CLLocationDistance?
        var theOrigin: CLLocation?
        var theDest: CLLocation?
        
        self.fetchCLLocation(address: origin, completionHandler: { (originLocation, originError) in
            if (originError == nil){
                theOrigin = originLocation
                NSLog("done 1")
            }else{
                NSLog(originError!)
            }
        })
        
        self.fetchCLLocation(address: destination, completionHandler: { (destLocation, destError) in
            if (destError == nil){
                theDest = destLocation
                NSLog("done 2")
                if let theOrigin = theOrigin, let theDest = theDest{
                    let distanceMeters = theOrigin.distance(from: theDest)
                    theDistance = distanceMeters
                    completionHandler(theDistance, nil)
                    NSLog("done 3 \(theDistance! * 0.001)KM")
                }
            }else{
                NSLog(destError!)
            }
        })
        
    }
}

