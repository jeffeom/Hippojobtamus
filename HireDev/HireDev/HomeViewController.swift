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

    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    

}
