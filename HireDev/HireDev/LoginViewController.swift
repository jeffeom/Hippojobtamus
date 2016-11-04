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
import FontAwesome_swift

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    
    let ref = FIRDatabase.database().reference(withPath: "users")
    var emailVerification: Bool = false
    
    //MARK: IBOutlets
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailLogo: UIImageView!
    @IBOutlet weak var fbLogo: UIImageView!
    @IBOutlet weak var signInLogo: UIImageView!
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let email = UserDefaults.standard.object(forKey: "email"){
            self.checkIfUserExists(email: email as! String)
        }else{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.emailLogo?.isHighlighted = false
            self.fbLogo?.isHighlighted = false
            
            self.errorLabel.text = ""
        }
    }
    
    //MARK: Button Functions
    
    @IBAction func loginEmailButtonClicked(_ sender: AnyObject) {
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if let _ = error{
                self.errorLabel.text = "\(error.unsafelyUnwrapped.localizedDescription)"
                self.passwordField.text = ""
                self.signInLogo.isHighlighted = false
            }else{
                if (FIRAuth.auth()?.currentUser?.isEmailVerified)!{
                    let userRef = self.ref.child((FIRAuth.auth()!.currentUser!.email?.replacingOccurrences(of: ".", with: ""))!)
                    userRef.child("emailVerify").setValue(true)
                    
                    self.verifiedUser()
                }else{
                    self.errorLabel.text = "You need to verify your email first"
                    self.passwordField.text = ""
                    self.signInLogo.isHighlighted = false
                }
            }
        }
    }
    
    @IBAction func loginFBButtonClicked(_ sender: AnyObject) {
        
        let login: FBSDKLoginManager = FBSDKLoginManager.init()
        
        login.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if (error != nil){
                self.errorLabel.text = "Facebook Process Error"
                self.fbLogo.isHighlighted = false
            }else if (result?.isCancelled)!{
                self.errorLabel.text = "Facebook Canceled"
                self.fbLogo.isHighlighted = false
            }else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if let _ = error{
                        self.errorLabel.text = "\(error.unsafelyUnwrapped.localizedDescription)"
                    }else{
                        
                        self.ref.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                            
                            if !snapshot.hasChild((user?.email?.replacingOccurrences(of: ".", with: ""))!){
                                let fullName: [String] = (user?.displayName!.components(separatedBy: " "))!
                                
                                let firstName = fullName[0]
                                let lastName = fullName[1]
                                
                                let aUser = User(uid: (user?.uid)!, firstName: firstName, lastName: lastName, email: FIRAuth.auth()!.currentUser!.email!, emailVerify: true, currentLocation: [0.0], searchDistance: 10.0, searchHistory: [""], uploadedPosts: [""], favoredPosts: [""])
                                
                                let userRef = self.ref.child((FIRAuth.auth()!.currentUser!.email?.replacingOccurrences(of: ".", with: ""))!)
                                userRef.setValue(aUser.toAnyObject())
                            }
                        })
                        self.verifiedUser()
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
    
    //MARK: Button Images
    
    @IBAction func fbTouchDown(_ sender: AnyObject) {
        fbLogo.highlightedImage = UIImage.init(named: "fbutton1")
        fbLogo.isHighlighted = true
    }
    @IBAction func emailTouchDown(_ sender: AnyObject) {
        emailLogo.highlightedImage = UIImage.init(named: "ebutton1")
        emailLogo.isHighlighted = true
    }
    @IBAction func signinTouchDown(_ sender: AnyObject) {
        signInLogo.highlightedImage = UIImage.init(named: "signin1")
        signInLogo.isHighlighted = true
    }
    
    //MARK: Navigate if Verified
    
    func verifiedUser() {
        if let _ = UserDefaults.standard.object(forKey: "uid"){
            let confirmedViewController = self.storyboard?.instantiateViewController(withIdentifier: "verifiedVC")
            self.navigationController?.pushViewController(confirmedViewController!
                , animated: true)
        }else{
            UserDefaults.standard.set(FIRAuth.auth()!.currentUser!.uid, forKey: "uid")
            UserDefaults.standard.set(FIRAuth.auth()!.currentUser!.email, forKey: "email")
            UserDefaults.standard.synchronize()
            let confirmedViewController = self.storyboard?.instantiateViewController(withIdentifier: "verifiedVC")
            self.navigationController?.pushViewController(confirmedViewController!
                , animated: true)
        }
    }
    
    func checkIfUserExists(email: String) {
        let userRef = FIRDatabase.database().reference(withPath: "users")
        let userId = email.replacingOccurrences(of: ".", with: "")
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(userId){
                self.verifiedUser()
            }else{
                return
            }
        })
    }
    
    
    // MARK: Keyboard Functions
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if (textField == emailField){
            passwordField.becomeFirstResponder()
        } else if (textField == passwordField) {
            textField.resignFirstResponder()
            self.signInButton.sendActions(for: .touchUpInside)
        }
        return false
    }
}
