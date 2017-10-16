//
//  Distance.swift
//  Hippo
//
//  Created by Jeff Eom on 2017-08-06.
//  Copyright © 2017 Jeff Eom. All rights reserved.
//

import SwiftyJSON

public struct Distance {
  public let distance: Double
  
  init?(json: JSON) {
    guard let distance = json["rows"][0]["elements"][0]["distance"]["value"].double else { return nil }
    self.distance = distance
  }
}
