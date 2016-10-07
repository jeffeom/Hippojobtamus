//
//  HomeViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-16.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    var latestContents = [JobItem]()
    
    let ref = FIRDatabase.database().reference(withPath: "job-post")
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpLocationForButton(locationButton: locationButton)
        
        ref.child("All").observe(.value, with: { snapshot in
            var latestItems: [JobItem] = []
            var fiveItems: [JobItem] = []
            
            for item in snapshot.children {
                let jobItem = JobItem(snapshot: item as! FIRDataSnapshot)
                latestItems.append(jobItem)
                
                if latestItems.count < 5 {
                    fiveItems.append(jobItem)
                }
            }
            
            self.latestContents = fiveItems
            self.latestCollectionView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor.init(red: 216.0/255.0, green: 225.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        nav?.tintColor = UIColor.init(red: 56.0/255.0, green: 61.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(red: 56.0/255.0, green: 61.0/255.0, blue: 59.0/255.0, alpha: 1.0)]
        
        if let font = UIFont(name: "GillSans-UltraBold", size: 15) {
            nav?.titleTextAttributes = [NSFontAttributeName: font]
        }
        
        self.tabBarController?.tabBar.barTintColor = UIColor.init(red: 56.0/255.0, green: 61.0/255.0, blue: 59.0/255.0, alpha: 0.2)
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.setUpLocationForButton(locationButton: locationButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //MARK: CollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return latestContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! LatestJobCollectionViewCell
        
        let latestContent = self.latestContents[(indexPath as NSIndexPath).item]
        
        cell.imageView.image = self.getImageFromString(string: latestContent.photo)
        cell.titleLabel.text = latestContent.title
        cell.dateLabel.text = latestContent.date
        
        return cell
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
        }
    }
    
    //MARK: IBAction
    
    @IBAction func locationSetting(_ sender: AnyObject) {
        let locationSettingController = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
        self.navigationController?.pushViewController(locationSettingController!
            , animated: true)
    }
    
    //MARK: Function
    
    func getImageFromString(string: String) -> UIImage {
        let data: NSData = NSData.init(base64Encoded: string, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        let image: UIImage = UIImage.init(data: data as Data)!
        
        return image
    }
    
    
}
