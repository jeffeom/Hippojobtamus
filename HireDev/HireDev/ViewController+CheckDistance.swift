//
//  ViewController+CheckDistance.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-10-04.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

extension UIViewController{
    func checkDistance(origin: String, destination: String, completion: @escaping (_ success: Bool) -> ()){
        var myBool: Bool = false
        var measuredDistances: [Float] = []
        
        DispatchQueue.global(qos: .default).async{
            
            var keys: NSDictionary?
            
            if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
                keys = NSDictionary(contentsOfFile: path)
            }
            if let dict = keys {
                let api = dict["googleDistance"] as? String
                
                let requestURL: NSURL = NSURL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(origin)&destinations=\(destination)&key=\(api!)")!
                
                let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
                let session = URLSession.shared
                let task = session.dataTask(with: urlRequest as URLRequest) {
                    (data, response, error) -> Void in
                    
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    if (statusCode == 200) {
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String: Any]
                            
                            if let rows = json?["rows"] as? [[String: Any]] {
                                for aRow in rows {
                                    if let elements = aRow["elements"] as? [[String: Any]] {
                                        for aElement in elements{
                                            if let distance = aElement["distance"] as? [String: Any]{
                                                measuredDistances.append(distance["value"]! as! Float)
                                            }
                                        }
                                    }
                                }
                            }
                        }catch {
                            print("Error with Json: \(error)")
                        }
                    }
                }
                task.resume()
            }
            
            DispatchQueue.main.async {
                
                let userDistanceRequest = UserDefaults.standard.integer(forKey: "searchDistance")
                let readableDistanceRequest = userDistanceRequest * 1000
                
                if let aDistance = measuredDistances.first{
                    
                    if aDistance > Float(readableDistanceRequest){
                        myBool = false
                    }else{
                        myBool = true
                    }
                }else{
                    NSLog("Error")
                    myBool = false
                }
                
                completion(myBool)
            }
        }
    }
}

