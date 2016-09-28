//
//  HomeViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-16.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: Properties
    
    var cafeObjects = [AnyObject]()
    var serverObjects = [AnyObject]()
    var tutorObjects = [AnyObject]()
    var salesObjects = [AnyObject]()
    var allObjects = [AnyObject]()
    var receptionObjects = [AnyObject]()
    var groceryObjects = [AnyObject]()
    var bankObjects = [AnyObject]()
    var othersObjects = [AnyObject]()
    
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cafeObjects = (["herro, cafe"] as AnyObject) as! [AnyObject]
        serverObjects = (["hi, server"] as AnyObject) as! [AnyObject]
        
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
                controller.contents = cafeObjects
            case "serverTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = serverObjects
            case "tutorTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = tutorObjects
            case "salesTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = salesObjects
            case "allTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = allObjects
            case "receptionTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = receptionObjects
            case "groceryTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = groceryObjects
            case "bankTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = bankObjects
            case "othersTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = othersObjects
            default:
                NSLog("Wrong Segue")
            }
        }else{
            NSLog("Segue nil")
        }
    }
}
