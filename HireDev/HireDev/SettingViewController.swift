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
    
    
    
    //MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutButton(_ sender: AnyObject) {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        
        self.showAlert(text: "You have successfully signed out", title: "Success!") { 
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
            self.present(vc!, animated: true)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
