//
//  MapsRouter.swift
//  Hippo
//
//  Created by Jeff Eom on 2017-08-06.
//  Copyright © 2017 Jeff Eom. All rights reserved.
//

import Alamofire

enum MapsRouter: URLRequestConvertible {
  case getDistance(origin: String, destination: String)
  case getLatLong(address: String)
  
  
  func asURLRequest() throws -> URLRequest {
    var method: HTTPMethod {
      switch self {
      case .getDistance, .getLatLong:
        return .get
      }
    }
    
    let params: [String: String]? = {
      guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist") else { return nil }
      guard let keys = NSDictionary(contentsOfFile: path) else { return nil }
      switch self {
      case let .getDistance(origin, destination):
        guard let key = keys["googleDistance"] as? String else { return nil }
        return ["origins": origin, "destinations": destination, "key": key]
      case let .getLatLong(address):
        guard let key = keys["googleGeocode"] as? String else { return nil }
        return ["address": address, "key": key]
      }
    }()
    
    var url: URL {
      var relativePath: String
      switch self {
      case .getDistance:
        if let params = params, let origins = params["origins"], let destinations = params["destinations"], let key = params["key"] {
          relativePath = "distancematrix/json?origins=\(origins)&destinations=\(destinations)&key=\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }else {
          relativePath = ""
        }
      case .getLatLong:
        relativePath = "geocode/json"
      }
      let url = URL(string: HippoApiManager.baseURLString + relativePath)!
      return url
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    
    return try JSONEncoding.default.encode(urlRequest)
  }
}
