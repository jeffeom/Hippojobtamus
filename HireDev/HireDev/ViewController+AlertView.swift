//
//  ViewController+AlertView.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-27.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import SwiftSpinner

extension UIViewController{
  func showAlert(_ text : NSString, title : NSString, fn:@escaping ()->Void){
    let alert = UIAlertController(title: title as String, message: text as String, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in fn()}))
    alert.show()
  }
  
  func currentLocationNeeded() {
    let alert = UIAlertController(title: "Current Location Needed", message: "Please set your current location", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Location Settings", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
      
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
      self.navigationController?.pushViewController(vc!, animated: true)
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
      return
    }))
    SwiftSpinner.hide()
    alert.show()
  }
  
  func noJobsFound() {
    let serachDistance = UserDefaults.standard.integer(forKey: "searchDistance")
    let alert = UIAlertController(title: "No jobs found", message: "Could not find any jobs within \(serachDistance) Km. Please increase the Search Distance", preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(UIAlertAction(title: "Location Settings", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
      
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
      self.navigationController?.pushViewController(vc!, animated: true)
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
      return
    }))
    SwiftSpinner.hide()
    alert.show()
  }
  
  func areaNotAvailable() {
    let alert = UIAlertController(title: "Not Available", message: "Not available in this area", preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(UIAlertAction(title: "Location Settings", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
      
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
      self.navigationController?.pushViewController(vc!, animated: true)
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
      return
    }))
    SwiftSpinner.hide()
    alert.show()
  }
}
