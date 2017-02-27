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
            
            print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
            bannerView.adUnitID = gaAPI!
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBOutlet
    
    @IBAction func myPosts(_ sender: Any) {
        let myPosts = ProfileSettingViewController(nibName: "ProfileSettings", bundle: nil)
        self.navigationController?.pushViewController(myPosts, animated: true)
    }
    
    @IBAction func myRewards(_ sender: Any) {
    }
    
    @IBAction func starredPosts(_ sender: Any) {
    }
}
