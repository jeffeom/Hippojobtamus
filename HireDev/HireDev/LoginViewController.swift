//
//  LoginViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-08.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var facebookView: UIView!
    //@IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func loginEmailButtonClicked(_ sender: AnyObject) {
        if let _ = emailField.text, let _ = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if let _ = error{
                    NSLog("Error occured during login process: \(error)")
                }else{
                    let confirmedViewController = self.storyboard?.instantiateViewController(withIdentifier: "master")
                    self.navigationController?.pushViewController(confirmedViewController!
                        , animated: true)
                }
            }
        }else{
            NSLog("email or password are blank")
        }
    }
    
    @IBAction func loginFBButtonClicked(_ sender: AnyObject) {
        let login: FBSDKLoginManager = FBSDKLoginManager.init()
        
        login.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if (error != nil){
                NSLog("Process Error")
            }else if (result?.isCancelled)!{
                NSLog("Canceled")
            }else {
                NSLog("Logged In")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if let error = error{
                        NSLog("Error occured: \(error)")
                    }else{
                        NSLog("User: \(user?.displayName), \(user?.email)")
                        let confirmedViewController = self.storyboard?.instantiateViewController(withIdentifier: "master")
                        self.navigationController?.pushViewController(confirmedViewController!
                            , animated: true)
                    }
                }
            }
        }
    }
}
