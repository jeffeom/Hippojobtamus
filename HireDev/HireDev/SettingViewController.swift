//
//  SettingViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-24.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBAction func signOutButton(_ sender: AnyObject) {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        
        self.showAlert(text: "You have successfully signed out", title: "Success!") {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
            self.present(vc!, animated: true)
        }
    }
    
    
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
    
    @IBAction func profileClicked(_ sender: AnyObject) {
        self.view.viewWithTag(1)?.backgroundColor = UIColor.blue
    }
    @IBAction func locationClicked(_ sender: AnyObject) {
        
    }
    @IBAction func feedbackClicked(_ sender: AnyObject) {
        
    }
    @IBAction func rateClicked(_ sender: AnyObject) {
        
    }
    @IBAction func helpClicked(_ sender: AnyObject) {
        
    }
    @IBAction func aboutClicked(_ sender: AnyObject) {
        
    }
    
    
}
