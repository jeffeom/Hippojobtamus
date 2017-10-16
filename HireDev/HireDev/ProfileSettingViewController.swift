//
//  ProfileSettingViewController.swift
//  Hippo
//
//  Created by Jeff Eom on 2017-02-26.
//  Copyright © 2017 Jeff Eom. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ProfileSettingViewController: UIViewController {
  
  @IBOutlet weak var bannerView: GADBannerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Profile Settings"
    
    var keys: NSDictionary?
    
    if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }
    if let dict = keys {
      let gaAPI = dict["googleBanner"] as? String
      
      //            bannerView.adUnitID = gaAPI!
      bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // TEST
      bannerView.rootViewController = self
      bannerView.load(GADRequest())
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: IBOutlet
  
  @IBAction func myPosts(_ sender: Any) {
    let myStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
    let vc = myStoryboard.instantiateViewController(withIdentifier: "tableVC") as! TableViewController
    vc.contents = "myPosts"
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func myRewards(_ sender: Any) {
  }
  
  @IBAction func starredPosts(_ sender: Any) {
    let myStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
    let vc = myStoryboard.instantiateViewController(withIdentifier: "tableVC") as! TableViewController
    vc.contents = "myFavorites"
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
