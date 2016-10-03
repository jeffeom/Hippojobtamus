//
//  ViewController+SetLocation.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-10-03.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

extension UIViewController{
    func setUpLocationForButton(locationButton: UIButton) {
        if let _ = UserDefaults.standard.string(forKey: "currentLocation"){
            
            locationButton.setTitle(UserDefaults.standard.string(forKey: "currentLocation"), for: .normal)
        }else{
            
            locationButton.setTitle("Please press to setup an address", for: .normal)
        
        }
    }
    
    func setUpLocationForLabel(locationLabel: UILabel) {
        if let _ = UserDefaults.standard.string(forKey: "currentLocation"){
        
            locationLabel.text = UserDefaults.standard.string(forKey: "currentLocation")
            
        }else{
            
            locationLabel.text = UserDefaults.standard.string(forKey: "Please press to setup an address")

        }
    }
}
