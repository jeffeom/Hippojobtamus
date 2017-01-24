//
//  ViewController+SetLocation.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-10-03.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

extension UIViewController{
    func setUpLocationForButton(_ locationButton: UIButton) {
        if let _ = UserDefaults.standard.string(forKey: "fixedLocation"){
            
            locationButton.setTitle(UserDefaults.standard.string(forKey: "fixedLocation"), for: .normal)
        }else{
            
            locationButton.setTitle("Please press to setup an address", for: .normal)
        
        }
    }
    
    func setUpLocationForLabel(_ locationLabel: UILabel) {
        if let _ = UserDefaults.standard.string(forKey: "fixedLocation"){
        
            locationLabel.text = UserDefaults.standard.string(forKey: "fixedLocation")
            
        }else{
            
            locationLabel.text = "Please press to setup an address"
        }
    }
}
