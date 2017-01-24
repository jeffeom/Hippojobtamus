//
//  ViewController+getLatLong.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-10-07.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

extension UIViewController{
    func fetchLatLong(_ address: String, completion: @escaping (_ fetchedData: [String: Float]?) -> ()){
        
        var latLong: [String: Float] = [:]
        
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let dict = keys {
            let api = dict["googleGeocode"] as? String
            
            let url = "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)&key=\(api!)"
            
            let urlStr: String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            if let aURL = (URL(string: urlStr)){
                let requestURL = aURL
                let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
                let session = URLSession.shared
                
                let task = session.dataTask(with: urlRequest as URLRequest) {
                    (data, response, error) -> Void in
                    
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    if (statusCode == 200) {
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String: Any]
                            
                            if let rows = json?["results"] as? [[String: Any]] {
                                for aRow in rows {
                                    if let geometry = aRow["geometry"] as? [String: Any]{
                                        if let location = geometry["location"] as? [String : Float]{
                                            latLong = location
                                        }
                                    }
                                }
                                completion(latLong)
                            }
                        }catch {
                            print("Error with Json: \(error)")
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
