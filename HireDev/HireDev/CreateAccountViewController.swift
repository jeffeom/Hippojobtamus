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
    
    //MARK: Properties
    
    let ref = FIRDatabase.database().reference(withPath: "users")
    
    //MARK: IBOutlets
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
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
        if let _ = self.firstName.text, let _ = self.lastName.text, let _ = self.email.text{
            FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if let _ = error {
                    self.errorLabel.text = "\(error.unsafelyUnwrapped.localizedDescription)"
                }else{
                    FIRAuth.auth()?.currentUser?.sendEmailVerification()
                    
                    let aUser = User(uid: "", firstName: self.firstName.text!, lastName: self.lastName.text!, email: self.email.text!, emailVerify: false, currentLocation: [0.0], searchDistance: 10.0, searchHistory: [""], uploadedPosts: [""], favoredPosts: [""])
                    
                    let userRef = self.ref.child(self.email.text!.replacingOccurrences(of: ".", with: ""))
                    userRef.setValue(aUser.toAnyObject())
                    
                    if let navController = self.navigationController{
                        navController.popViewController(animated: true)
                        self.showAlert(text: "Please check your email", title: "Email verification Sent", fn: { 
                            return
                        })
                    }
                }
            })
        }else{
            self.showAlert(text: "You left one of the fields empty", title: "Please Try Again", fn: {
                return
            })
        }
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
