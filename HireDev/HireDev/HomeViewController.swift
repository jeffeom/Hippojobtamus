//
//  HomeViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-16.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    //MARK: Properties
    
    var cafeObjects = [JobItem]()
    var serverObjects = [JobItem]()
    var tutorObjects = [JobItem]()
    var salesObjects = [JobItem]()
    var allObjects = [JobItem]()
    var receptionObjects = [JobItem]()
    var groceryObjects = [JobItem]()
    var bankObjects = [JobItem]()
    var othersObjects = [JobItem]()
    var allItems = [JobItem]()

    @IBOutlet weak var locationButton: UIButton!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.setUpLocationForButton(locationButton: locationButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        self.setUpLocationForButton(locationButton: locationButton)

    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.identifier {
            switch segue.identifier! as String {
            case "cafeTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = "Cafe"
            case "serverTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = "Server"
            case "tutorTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = "Tutor"
            case "salesTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = "Sales"
            case "allTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = "All"
            case "receptionTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = "Reception"
            case "groceryTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = "Grocery"
            case "bankTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = "Bank"
            case "othersTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = "Others"
            default:
                NSLog("Wrong Segue")
            }
        }else{
            NSLog("Segue nil")
        }
    }
    
    //MARK: IBAction
    
    @IBAction func locationSetting(_ sender: AnyObject) {
        let locationSettingController = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
        self.navigationController?.pushViewController(locationSettingController!
            , animated: true)
    }
    

}
