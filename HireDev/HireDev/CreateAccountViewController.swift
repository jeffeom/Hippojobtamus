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
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func cancelClicked(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpClicked(_ sender: AnyObject) {
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
            if let _ = error {
                self.errorLabel.text = "\(error.unsafelyUnwrapped.localizedDescription)"
            }else{
                FIRAuth.auth()?.currentUser?.sendEmailVerification()
                NSLog("Email Sent")
                if let navController = self.navigationController{
                    navController.popViewController(animated: true)
                }
            }
        })
    }
}
