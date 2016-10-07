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
    
    var indicator = UIActivityIndicatorView()
    
    let ref = FIRDatabase.database().reference(withPath: "job-post")
    
    var rejectionCounter = 0
    var itemCounter = 0
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.color = UIColor.gray
        indicator.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        indicator.center = CGPoint.init(x: self.view.frame.midX, y: self.view.frame.height / 10)
        self.view.addSubview(indicator)
        indicator.bringSubview(toFront: self.view)
        indicator.startAnimating()
        
        self.setUpLocationForButton(locationButton: locationButton)
        
        ref.child("All").observe(.value, with: { snapshot in
            var latestItems: [JobItem] = []
            var fiveItems: [JobItem] = []
            
            for item in snapshot.children {
                let jobItem = JobItem(snapshot: item as! FIRDataSnapshot)
                self.itemCounter += 1
                
                let readableOrigin: String = (UserDefaults.standard.string(forKey: "currentLocation")?.replacingOccurrences(of: " ", with: ""))!
                let readableDestination: String = jobItem.location.replacingOccurrences(of: " ", with: "")
                
                self.checkDistance(origin: readableOrigin, destination: readableDestination) { (fetchedData) in
                    DispatchQueue.main.async {
                        
                        let userDistanceRequest = UserDefaults.standard.integer(forKey: "searchDistance")
                        let readableDistanceRequest = userDistanceRequest * 1000
                        
                        if let aDistance = fetchedData?.first{
                            if aDistance > Float(readableDistanceRequest){
                                self.rejectionCounter += 1
                                if self.rejectionCounter == self.itemCounter{
                                    let serachDistance = UserDefaults.standard.integer(forKey: "searchDistance")
                                    
                                    let alert = UIAlertController(title: "No jobs found", message: "Could not find any jobs within \(serachDistance) Km. Please increase the Search Distance", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    alert.addAction(UIAlertAction(title: "Location Settings", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                                        
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
                                        self.navigationController?.pushViewController(vc!, animated: true)
                                    }))
                                    
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
                                        return
                                    }))
                                    
                                    alert.show()
                                }
                                
                            }else{
                                
                                latestItems.append(jobItem)
                                
                                if latestItems.count < 5 {
                                    fiveItems.append(jobItem)
                                }
                                self.latestContents = fiveItems
                                self.latestCollectionView.reloadData()
                                
                                
                            }
                        }else{
                            self.rejectionCounter += 1
                            if self.rejectionCounter == self.itemCounter{
                                
                                let alert = UIAlertController(title: "Not Available", message: "Not available in this area", preferredStyle: UIAlertControllerStyle.alert)
                                
                                alert.addAction(UIAlertAction(title: "Location Settings", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                                    
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                }))
                                
                                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
                                    return
                                }))
                                alert.show()
                            }
                        }
                    }
                }
            }
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = UserDefaults.standard.string(forKey: "currentLocation"){
            
            ref.child("All").observe(.value, with: { snapshot in
                var latestItems: [JobItem] = []
                var fiveItems: [JobItem] = []
                
                for item in snapshot.children {
                    let jobItem = JobItem(snapshot: item as! FIRDataSnapshot)
                    self.itemCounter += 1
                    
                    let readableOrigin: String = (UserDefaults.standard.string(forKey: "currentLocation")?.replacingOccurrences(of: " ", with: ""))!
                    let readableDestination: String = jobItem.location.replacingOccurrences(of: " ", with: "")
                    
                    self.checkDistance(origin: readableOrigin, destination: readableDestination) { (fetchedData) in
                        DispatchQueue.main.async {
                            
                            let userDistanceRequest = UserDefaults.standard.integer(forKey: "searchDistance")
                            let readableDistanceRequest = userDistanceRequest * 1000
                            
                            if let aDistance = fetchedData?.first{
                                if aDistance > Float(readableDistanceRequest){
                                    self.rejectionCounter += 1
                                    if self.rejectionCounter == self.itemCounter{
                                        let serachDistance = UserDefaults.standard.integer(forKey: "searchDistance")
                                        
                                        let alert = UIAlertController(title: "No jobs found", message: "Could not find any jobs within \(serachDistance) Km. Please increase the Search Distance", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        alert.addAction(UIAlertAction(title: "Location Settings", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                                            
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
                                            self.navigationController?.pushViewController(vc!, animated: true)
                                        }))
                                        
                                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
                                            return
                                        }))
                                        
                                        alert.show()
                                    }
                                    
                                }else{
                                    latestItems.append(jobItem)
                                    
                                    if latestItems.count < 5 {
                                        fiveItems.append(jobItem)
                                    }
                                    self.latestContents = fiveItems
                                    self.latestCollectionView.reloadData()
                                }
                            }else{
                                self.rejectionCounter += 1
                                if self.rejectionCounter == self.itemCounter{
                                    
                                    let alert = UIAlertController(title: "Not Available", message: "Not available in this area", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    alert.addAction(UIAlertAction(title: "Location Settings", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                                        
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
                                        self.navigationController?.pushViewController(vc!, animated: true)
                                    }))
                                    
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
                                        return
                                    }))
                                    
                                    alert.show()
                                }
                            }
                        }
                    }
                }
                
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                
            })
        }else{
            let alert = UIAlertController(title: "Current Location Needed", message: "Please set your current location", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Location Settings", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
                self.navigationController?.pushViewController(vc!, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
                return
            }))
            
            alert.show()
            
        }
        
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor.init(red: 216.0/255.0, green: 225.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        nav?.tintColor = UIColor.init(red: 56.0/255.0, green: 61.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(red: 56.0/255.0, green: 61.0/255.0, blue: 59.0/255.0, alpha: 1.0)]
        
        nav?.titleTextAttributes = [NSFontAttributeName: UIFont(name: "GillSans-UltraBold", size: 20)!]
        
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
