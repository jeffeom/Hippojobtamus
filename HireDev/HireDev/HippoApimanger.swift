//
//  HippoApimanger.swift
//  Hippo
//
//  Created by Jeff Eom on 2017-08-06.
//  Copyright © 2017 Jeff Eom. All rights reserved.
//

import Alamofire
import SwiftyJSON

public enum Result<T> {
  case success(T)
  case failure(reason: String)
}

public final class HippoApiManager {
  enum APIError: Error {
    case noInternet
  }
  
  static let baseURLString = "https://maps.googleapis.com/maps/api/"
  static public let shared = HippoApiManager()
}

//MARK: MapsRouter

public extension HippoApiManager {
  func getDistance(origin: String, destination: String, completion: @escaping (Result<Distance?>) -> ()){
    Alamofire.request(MapsRouter.getDistance(origin: origin, destination: destination)).responseJSON { response in
      
      guard let response = response.result.value else { return completion(.failure(reason: "Unable to connect to the server.")) }
      let json = JSON(response)
      let distance = Distance(json: json)
      if distance != nil {
        completion(.success(distance))
      }else {
        completion(.failure(reason: "Object serialization failure."))
      }
    }
  }
}
