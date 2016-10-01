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
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
