//
//  HomeViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-16.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    //MARK: IBOutlets
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rejectionCounter = 0
        self.itemCounter = 0
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        indicator.color = UIColor.gray
        indicator.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        indicator.center = CGPoint.init(x: self.view.frame.midX, y: self.view.frame.height / 10)
        self.view.addSubview(indicator)
        indicator.bringSubview(toFront: self.view)
        indicator.startAnimating()
        
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let dict = keys {
            let gaAPI = dict["googleBanner"] as? String
            
            print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
            bannerView.adUnitID = gaAPI!
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        
        
        self.setUpLocationForButton(locationButton: locationButton)
        
        self.fetchDataFromDB()
        
        self.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.rejectionCounter = 0
        self.itemCounter = 0
        
        self.setUpLocationForButton(locationButton: locationButton)
        
        fetchDataFromDB()
        
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor.init(red: 0/255.0, green: 168.0/255.0, blue: 168.0/255.0, alpha: 1.0)
        //        nav?.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Futura-Medium", size: 20)!]
        //        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //
        let attrs = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Futura-MediumItalic", size: 25)!
        ]
        
        nav?.titleTextAttributes = attrs
        
        
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
        
        cell.titleLabel.text = latestContent.title
        cell.locationLabel.text = latestContent.location
        cell.dateLabel.text = latestContent.date
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let kWhateverHeightYouWant = 105
        return CGSize.init(width:collectionView.bounds.size.width, height:CGFloat(kWhateverHeightYouWant))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffsetScrolledRight: Float = Float(self.latestCollectionView.frame.size.width) * Float(self.latestContents.count - 1)
        
        if Float(scrollView.contentOffset.x) == contentOffsetScrolledRight{
            let newIndexPath: NSIndexPath = NSIndexPath.init(item: 0, section: 0)
            
            self.latestCollectionView.scrollToItem(at: newIndexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
        }else if scrollView.contentOffset.x == 0 {
            let newIndexPath: NSIndexPath = NSIndexPath.init(item: (self.latestContents.count - 1), section: 0)
            
            self.latestCollectionView.scrollToItem(at: newIndexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let contentOffsetScrolledRight: Float = Float(self.latestCollectionView.frame.size.width) * Float(self.latestContents.count - 1)
        
        if Float(scrollView.contentOffset.x) == contentOffsetScrolledRight{
            let newIndexPath: NSIndexPath = NSIndexPath.init(item: 0, section: 0)
            
            self.latestCollectionView.scrollToItem(at: newIndexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
        }else if scrollView.contentOffset.x == 0 {
            let newIndexPath: NSIndexPath = NSIndexPath.init(item: (self.latestContents.count - 1), section: 0)
            
            self.latestCollectionView.scrollToItem(at: newIndexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
        }
    }
    
    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.identifier {
            switch segue.identifier! as String {
            case "cafeTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = "Cafe"
            case "restaurantTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = "Restaurant"
            case "educationTable":
                let controller = segue.destination as! MasterViewController
                controller.contents = "Education"
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
            case "showDetail":
                let cell = sender as! LatestJobCollectionViewCell
                if let indexPath = self.latestCollectionView!.indexPath(for: cell) {
                    let categoryContent = self.latestContents[indexPath.item]
                    let controller = segue.destination as! DetailViewController
                    controller.detailItem = categoryContent as JobItem
                }
                
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
    
    func scrollToNextCell(){
        
        let collectionView = latestCollectionView
        
        //get cell size
        let cellSize = CGSize.init(width: self.view.frame.width, height: self.view.frame.height)
        
        //get current content Offset of the Collection view
        let contentOffset = collectionView?.contentOffset
        
        //scroll to next cell
        collectionView?.scrollRectToVisible(CGRect.init(x: (contentOffset?.x)! + cellSize.width, y: (contentOffset?.y)!, width: cellSize.width, height: cellSize.height), animated: true)
    }
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(HomeViewController.scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    func fetchDataFromDB() {
        if let _ = UserDefaults.standard.string(forKey: "currentLocation"){
            
            ref.child("All").observe(.value, with: { snapshot in
                var latestItems: [JobItem] = []
                
                for item in snapshot.children {
                    let jobItem = JobItem(snapshot: item as! FIRDataSnapshot)
                    self.itemCounter += 1
                    
                    let readableOrigin: String = (UserDefaults.standard.string(forKey: "currentLocation"))!
                    let readableDestination: String = jobItem.location
                    
                    self.checkDistance(origin: readableOrigin, destination: readableDestination) { (fetchedData) in
                        DispatchQueue.main.async {
                            
                            let userDistanceRequest = UserDefaults.standard.integer(forKey: "searchDistance")
                            let readableDistanceRequest = userDistanceRequest * 1000
                            
                            if let aDistance = fetchedData?.first{
                                if aDistance > Float(readableDistanceRequest){
                                    self.rejectionCounter += 1
                                    if self.rejectionCounter == self.itemCounter{
                                        
                                        self.showNoJobsFound()
                                        
                                    }
                                }else{
                                    latestItems.append(jobItem)
                                    
                                    if latestItems.count == snapshot.children.allObjects.count - 1{
                                        
                                        let firstItem =  latestItems[0]
                                        
                                        latestItems.append(firstItem)
                                    }
                                    
                                    self.latestContents = latestItems
                                    self.latestCollectionView.reloadData()
                                }
                            }else{
                                self.rejectionCounter += 1
                                if self.rejectionCounter == self.itemCounter{
                                    
                                    self.showNotAvailable()
                                    
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
    }
    
    func showNotAvailable() {
        let alert = UIAlertController(title: "Not Available", message: "Not available to show featured contents in this area. Please change the location.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Location Settings", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
            self.navigationController?.pushViewController(vc!, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
            return
        }))
        alert.show()
    }
    
    func showNoJobsFound() {
        let serachDistance = UserDefaults.standard.integer(forKey: "searchDistance")
        
        let alert = UIAlertController(title: "No jobs found", message: "Could not find any jobs within \(serachDistance) Km. Please increase the Search Distance Or upload a first post in your area", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Location Settings", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
            self.navigationController?.pushViewController(vc!, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Upload", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "uploadVC")
            self.tabBarController?.selectedViewController = vc
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
            return
        }))
        
        alert.show()
    }
}
