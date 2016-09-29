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
    
    let ref = FIRDatabase.database().reference(withPath: "job-post")
    var distributedItem: [String: [JobItem]] = ["Cafe":[], "Server":[], "Tutor":[], "Sales":[], "Reception":[], "Grocery":[], "Bank":[], "Others":[], "All":[]]
    let category: [String] = ["Cafe", "Server", "Tutor", "Sales", "Reception", "Grocery", "Bank", "Others", "All"]
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for aCategory in category{
            self.ref.child(aCategory).observe(.value, with: { (snapshot) in
                var newItems: [JobItem] = []
                
                for item in snapshot.children {
                    let jobItem = JobItem(snapshot: item as! FIRDataSnapshot)
                    newItems.append(jobItem)
                }
                self.distributeItem(item: newItems, name: aCategory)
                self.allObjects = self.distributedItem["All"]!
                self.cafeObjects = self.distributedItem["Cafe"]!
                self.serverObjects = self.distributedItem["Server"]!
                self.tutorObjects = self.distributedItem["Tutor"]!
                self.salesObjects = self.self.distributedItem["Sales"]!
                self.receptionObjects = self.distributedItem["Reception"]!
                self.groceryObjects = self.distributedItem["Grocery"]!
                self.bankObjects = self.distributedItem["Bank"]!
                self.othersObjects = self.distributedItem["Others"]!
            })
            
        }
        //        }
        //
        //        self.ref.observe(.value, with: { snapshot in
        //            var newItems: [JobItem] = []
        //
        //            for item in snapshot.children {
        //                let jobItem = JobItem(snapshot: item as! FIRDataSnapshot)
        //                newItems.append(jobItem)
        //            }
        //            self.distributeItem(item: newItems)
        //
        //            self.cafeObjects = self.distributedItem["Cafe"]!
        //            self.serverObjects = self.distributedItem["Server"]!
        //            self.tutorObjects = self.distributedItem["Tutor"]!
        //            self.salesObjects = self.self.distributedItem["Sales"]!
        //            self.receptionObjects = self.distributedItem["Reception"]!
        //            self.groceryObjects = self.distributedItem["Grocery"]!
        //            self.bankObjects = self.distributedItem["Bank"]!
        //            self.othersObjects = self.distributedItem["Others"]!
        //            self.allObjects = newItems
        //        })
        
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
    
    //MARK: Function
    
    func distributeItem(item: [JobItem], name: String){
        for aItem: JobItem in item{
            distributedItem[name]!.append(aItem)            
        }
    }
}
