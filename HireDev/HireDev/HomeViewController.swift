//
//  HomeViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-16.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource{
    
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
    let container: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 70, height: 70))
    let categoryString: [String] = ["cafe", "restaurant", "grocery", "bank", "All", "education", "retail", "receptionist", "others"]
    let categoryContents: [String] = ["Cafe", "Restaurant", "Grocery", "Bank", "All", "Education", "Sales", "Reception", "Others"]
    var loadingView: UIView = UIView()
    
    //MARK: IBOutlets
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var myTableView: UITableView!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rejectionCounter = 0
        self.itemCounter = 0
        
        container.backgroundColor = self.hexStringToUIColor(hex: "444444", alpha: 0.5)
        container.center = CGPoint.init(x: self.view.frame.midX, y: self.view.frame.midY / 6)
        container.layer.cornerRadius = 10
        self.latestCollectionView.addSubview(container)
        container.bringSubview(toFront: self.latestCollectionView)
        
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicator.frame = CGRect.init(x: 11.5, y: 11.5, width: 50, height: 50)
        container.addSubview(indicator)
        indicator.bringSubview(toFront: container)
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
        
        self.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.rejectionCounter = 0
        self.itemCounter = 0
        
        self.setUpLocationForButton(locationButton: locationButton)
        
        loadingView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        loadingView.backgroundColor = UIColor.yellow
        
        self.view.addSubview(loadingView)
        
        fetchDataFromDB()
        
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor.init(red: 0/255.0, green: 168.0/255.0, blue: 168.0/255.0, alpha: 1.0)
        
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
        
        if collectionView == latestCollectionView{
            return latestContents.count
        }else{
            return categoryString.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if collectionView == latestCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! LatestJobCollectionViewCell
            
            let latestContent = self.latestContents[(indexPath as NSIndexPath).item]
            
            cell.titleLabel.text = latestContent.title
            cell.locationLabel.text = latestContent.location
            cell.dateLabel.text = latestContent.date
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
            
            cell.categoryImage.image = UIImage.init(named: categoryString[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == latestCollectionView{
            let cellHeight = 100
            return CGSize.init(width:collectionView.bounds.size.width, height:CGFloat(cellHeight))
        }else{
            let cellHeight = 100
            return CGSize.init(width:collectionView.bounds.size.width / 4, height:CGFloat(cellHeight))
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == latestCollectionView{
            let contentOffsetScrolledRight: Float = Float(self.latestCollectionView.frame.size.width) * Float(self.latestContents.count - 1)
            
            if Float(scrollView.contentOffset.x) == contentOffsetScrolledRight{
                let newIndexPath: NSIndexPath = NSIndexPath.init(item: 1, section: 0)
                
                self.latestCollectionView.scrollToItem(at: newIndexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
            }else if scrollView.contentOffset.x == 0 {
                let newIndexPath: NSIndexPath = NSIndexPath.init(item: (self.latestContents.count - 2), section: 0)
                
                self.latestCollectionView.scrollToItem(at: newIndexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        if scrollView == latestCollectionView{
            let contentOffsetScrolledRight: Float = Float(self.latestCollectionView.frame.size.width) * Float(self.latestContents.count - 1)
            
            if Float(scrollView.contentOffset.x) == contentOffsetScrolledRight{
                let newIndexPath: NSIndexPath = NSIndexPath.init(item: 1, section: 0)
                
                self.latestCollectionView.scrollToItem(at: newIndexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
            }else if scrollView.contentOffset.x == 0 {
                let newIndexPath: NSIndexPath = NSIndexPath.init(item: (self.latestContents.count - 2), section: 0)
                
                self.latestCollectionView.scrollToItem(at: newIndexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
            }
        }
    }
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latestContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestCell", for: indexPath) as! SuggestTableViewCell
        
        if (latestContents.count != 0) {
            let categoryContents = self.latestContents[(indexPath as NSIndexPath).row]
            
            DispatchQueue.global(qos: .userInteractive).async {
                let data: NSData = NSData.init(base64Encoded: categoryContents.photo, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
                let image: UIImage = UIImage.init(data: data as Data)!
                
                DispatchQueue.main.async {
                    cell.myImageView.image = image
                    cell.titleLabel!.text = categoryContents.title
                    cell.locationLabel.text = categoryContents.location
                    cell.setNeedsLayout() //invalidate current layout
                    cell.layoutIfNeeded() //update immediately
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.tintColor = UIColor.white
        cell.backgroundColor = UIColor.clear
    }
    
    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.identifier {
            switch segue.identifier! as String {
                
            case "showDetail":
                let cell = sender as! LatestJobCollectionViewCell
                if let indexPath = self.latestCollectionView!.indexPath(for: cell) {
                    let categoryContent = self.latestContents[indexPath.item]
                    let controller = segue.destination as! DetailViewController
                    controller.detailItem = categoryContent as JobItem
                }
            case "categoryShow":
                let cell = sender as! CategoryCollectionViewCell
                if let indexPath = self.categoryCollectionView!.indexPath(for: cell) {
                    let categoryContent = self.categoryContents[indexPath.item]
                    let controller = segue.destination as! MasterViewController
                    controller.contents = categoryContent
                }
            case "showDetail2":
                let cell = sender as! SuggestTableViewCell
                if let indexPath = self.myTableView!.indexPath(for: cell) {
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
                                    
                                    if latestItems.count == snapshot.children.allObjects.count - self.rejectionCounter{
                                        
                                        let firstItem =  latestItems.first
                                        let lastItem = latestItems.last
                                        
                                        latestItems.append(firstItem!)
                                        latestItems.insert(lastItem!, at: 0)
                                        
                                        self.itemCounter = 0
                                        self.rejectionCounter = 0
                                    }
                                    
                                    self.latestContents = latestItems
                                    self.latestCollectionView.reloadData()
                                    self.myTableView.reloadData()
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
                self.container.isHidden = true
                for v in self.view.subviews{
                    if v == self.loadingView{
                        v.removeFromSuperview()
                    }
                }
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
            
            let vc = self.tabBarController?.viewControllers?[1]
            self.tabBarController?.selectedViewController = vc
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
            return
        }))
        
        alert.show()
    }
}
