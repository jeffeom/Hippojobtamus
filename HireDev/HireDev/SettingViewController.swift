//
//  SettingViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-24.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import MessageUI
import GoogleMobileAds
import FBSDKLoginKit

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var versionLabel: UILabel!
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let dict = keys {
            let gaAPI = dict["googleBanner"] as? String
                        
            //            bannerView.adUnitID = gaAPI!
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // TEST
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let dict = keys {
            if let version = dict["CFBundleVersion"] as? String{
                self.versionLabel.text = "V" + version
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor.init(red: 255.0/255.0, green: 121.0/255.0, blue: 121.0/255.0, alpha: 1.0)
        nav?.isTranslucent = false
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        nav?.tintColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //MARK: Button Actions
    
    @IBAction func logOutClicked(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Do you want to log out?", message: "You will lose all of your location history", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Log out", style: UIAlertActionStyle.destructive, handler: {(alert: UIAlertAction!) in
            
            let appDomain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            
            FBSDKAccessToken.setCurrent(nil)
            
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
        if (UIApplication.shared.canOpenURL(URL(string:"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(1163603705)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")! as URL)){
            if let url = URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(1163603705)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
        

    }
    @IBAction func helpClicked(_ sender: AnyObject) {
        
    }

    @IBAction func termsOfService(_ sender: AnyObject) {
        
    }
    
    @IBAction func profileSettingClicked(_ sender: Any) {
        let profileVC = ProfileSettingViewController(nibName: "ProfileSettings", bundle: nil)
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}
