//
//  SettingViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-24.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
    
    @IBAction func logOutClicked(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Do you want to log out?", message: "You will lose all of your location history", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Log out", style: UIAlertActionStyle.destructive, handler: {(alert: UIAlertAction!) in
            
            let appDomain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
            self.present(vc!, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
            return
        }))
        
        alert.show()
    }
    
    //MARK: MFMailComposeVCDelegate
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["hippojobtamus@gmail.com"])
        mailComposerVC.setSubject("[Feedback for Hippo]")
        mailComposerVC.setMessageBody("Your app is not so bad! I wish there was: ", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send email. Please check email configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        sendMailErrorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert: UIAlertAction) in
            return
        }))
        
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: IBAction
    
    @IBAction func feedbackClicked(_ sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func rateClicked(_ sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    @IBAction func helpClicked(_ sender: AnyObject) {
        
    }

    @IBAction func termsOfService(_ sender: AnyObject) {
        
    }
    
    
}
