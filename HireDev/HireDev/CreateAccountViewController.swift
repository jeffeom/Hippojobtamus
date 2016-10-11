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
    
    //MARK: IBOutlets
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: Button functions
    
    @IBAction func cancelClicked(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpClicked(_ sender: AnyObject) {
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
            if let _ = error {
                self.errorLabel.text = "\(error.unsafelyUnwrapped.localizedDescription)"
            }else{
                FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
                    if let _ = error {
                        NSLog("\(error?.localizedDescription)")
                    }else{
                        if let navController = self.navigationController{
                            navController.popViewController(animated: true)
                        }
                    }
                })
            }
        })
    }
    
    //MARK: Keyboard functions
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2.5
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height / 2.5
            }
        }
    }
}
