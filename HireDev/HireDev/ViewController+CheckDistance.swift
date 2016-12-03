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
                }
            }
            NSLog("fetchcllocation")
            completionHandler(setLocation, error)
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
                    
                    if let _ = distanceMeters{
                        NSLog("\(origin), \(destination): checkdistance got \(distanceMeters)")
                        completionHandler(distanceMeters, error)
                    }else{
                        return
                    }
                })
            }
            
        })
    }
    
    
    
    
    
    
    
    
    
    //
    //
    //        NSLog("gonna check distance")
    //        DispatchQueue.global(qos: .userInitiated).async {
    //            var measuredDistances: [Float] = []
    //
    //            var keys: NSDictionary?
    //
    //            if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
    //                keys = NSDictionary(contentsOfFile: path)
    //            }
    //            if let dict = keys {
    //                let api = dict["googleDistance"] as? String
    //
    //                let url : String = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(origin)&destinations=\(destination)&key=\(api!)"
    //                let urlStr: String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    //
    //                let requestURL: NSURL = NSURL(string: urlStr)!
    //
    //                let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
    //                let session = URLSession.shared
    //
    //                let task = session.dataTask(with: urlRequest as URLRequest) {
    //                    (data, response, error) -> Void in
    //
    //                    let httpResponse = response as! HTTPURLResponse
    //                    let statusCode = httpResponse.statusCode
    //
    //                    if (statusCode == 200) {
    //                        do{
    //                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String: Any]
    //
    //                            if let rows = json?["rows"] as? [[String: Any]] {
    //                                for aRow in rows {
    //                                    NSLog("Looping 1")
    //                                    if let elements = aRow["elements"] as? [[String: Any]] {
    //                                        for aElement in elements{
    //                                            NSLog("Looping 2")
    //                                            if let distance = aElement["distance"] as? [String: Any]{
    //                                                measuredDistances.append(distance["value"]! as! Float)
    //                                            }
    //                                        }
    //                                        completion(measuredDistances)
    //                                        NSLog("Looping 2 End")
    //                                    }
    //                                }
    //                                NSLog("Looping 1 End")
    //                            }
    //                        }catch {
    //                            print("Error with Json: \(error)")
    //                        }
    //                    }
    //                }
    //                task.resume()
    //            }
    //        }
    //        NSLog("End checking distance")
    //    }
}

