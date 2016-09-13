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
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var emailLogo: UIImageView!
    @IBOutlet weak var fbLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.emailLogo?.isHighlighted = false
        self.fbLogo?.isHighlighted = false
        
        self.errorLabel.text = ""
    }
    
    @IBAction func loginEmailButtonClicked(_ sender: AnyObject) {
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if let _ = error{
                self.errorLabel.text = "\(error.unsafelyUnwrapped.localizedDescription)"
                self.passwordField.text = ""
            }else{
                if (FIRAuth.auth()?.currentUser?.isEmailVerified)!{
                    self.verifiedUser()
                }else{
                    self.errorLabel.text = "You need to verify your email first"
                    self.passwordField.text = ""
                }
            }
        }
    }
    
    @IBAction func loginFBButtonClicked(_ sender: AnyObject) {
        
        let login: FBSDKLoginManager = FBSDKLoginManager.init()
        
        login.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if (error != nil){
                self.errorLabel.text = "Facebook Process Error"
            }else if (result?.isCancelled)!{
                self.errorLabel.text = "Facebook Canceled"
            }else {
                self.errorLabel.text = "Logged In"
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if let _ = error{
                        self.errorLabel.text = "\(error.unsafelyUnwrapped.localizedDescription)"
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
    
    @IBAction func forgotPassword(_ sender: AnyObject) {
        if emailField.text != "" {
            FIRAuth.auth()?.sendPasswordReset(withEmail: emailField.text!, completion: { (error) in
                if let _ = error{
                    self.errorLabel.text = "\(error.unsafelyUnwrapped.localizedDescription)"
                }else{
                    self.errorLabel.text = "Reset password has been sent!"
                }
            })
        }else{
            self.errorLabel.text = "Type in the email first and re-try it"
        }
    }
    @IBAction func fbTouchDown(_ sender: AnyObject) {
        fbLogo.highlightedImage = UIImage.init(named: "facebooklogopressed")
        fbLogo.isHighlighted = true
    }
    @IBAction func emailTouchDown(_ sender: AnyObject) {
        emailLogo.highlightedImage = UIImage.init(named: "emaillogopressed")
        emailLogo.isHighlighted = true
    }
    
    func verifiedUser() {
        let confirmedViewController = self.storyboard?.instantiateViewController(withIdentifier: "master")
        self.navigationController?.pushViewController(confirmedViewController!
            , animated: true)
    }
}
