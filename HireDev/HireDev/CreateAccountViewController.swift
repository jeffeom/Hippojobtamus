//
//  CreateAccountViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-09.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBAction func cancelClicked(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpClicked(_ sender: AnyObject) {
        if let _ = email.text, let _ = password.text {
            if (email.text != nil && password.text != nil && password.text == confirmPassword.text) {
                FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                    if let _ = error {
                        NSLog("Error occured \(error)")
                    }else{
                        let confirmedViewController = self.storyboard?.instantiateViewController(withIdentifier: "master")
                        self.navigationController?.pushViewController(confirmedViewController!
                            , animated: true)
                    }
                })
            }else{
                NSLog("password and confirmpassword do not match")
            }
        }
        else{
            NSLog("email or password is empty")
        }
    }
}
