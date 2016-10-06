//
//  SettingViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-24.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor.init(red: 216.0/255.0, green: 225.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(red: 56.0/255.0, green: 61.0/255.0, blue: 59.0/255.0, alpha: 1.0)]
    }
    
    //MARK: Button Actions
    
    @IBAction func logOutClicked(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Do you want to log out?", message: "You will lose all of your location history", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Log out", style: UIAlertActionStyle.destructive, handler: {(alert: UIAlertAction!) in
            
            let appDomain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
            self.present(vc!, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
            return
        }))
        
        alert.show()
    }
    
    
    @IBAction func feedbackClicked(_ sender: AnyObject) {
        
    }
    @IBAction func rateClicked(_ sender: AnyObject) {
        
    }
    @IBAction func helpClicked(_ sender: AnyObject) {
        
    }

    
    @IBAction func PrivacyPolicy(_ sender: AnyObject) {
    }
    
    @IBAction func termsOfService(_ sender: AnyObject) {
    }
    
    
}
