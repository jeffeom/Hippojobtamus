//
//  HomeViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-16.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner

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
  let ref = Database.database().reference(withPath: "job-post")
  var rejectionCounter = 0
  var itemCounter = 0
  var container = UIView() {
    didSet{
      container = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 70, height: 70))
      container.backgroundColor = self.hexStringToUIColor("444444", alpha: 1)
      container.center = CGPoint.init(x: self.view.bounds.width / 2, y: self.categoryCollectionView.bounds.size.height / 2)
      container.layer.cornerRadius = 10
      self.latestCollectionView.addSubview(container)
      container.bringSubview(toFront: self.latestCollectionView)
    }
  }
  var indicator = UIActivityIndicatorView() {
    didSet{
      indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
      indicator.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
      indicator.center = CGPoint.init(x: self.container.bounds.size.width / 2, y: self.container.bounds.size.height / 2)
      container.addSubview(indicator)
      indicator.bringSubview(toFront: container)
      indicator.startAnimating()
    }
  }
  let categoryString: [String] = ["cafe", "restaurant", "grocery", "bank", "All", "education", "retail", "receptionist", "others"]
  let categoryContents: [String] = ["Cafe", "Restaurant", "Grocery", "Bank", "All", "Education", "Sales", "Reception", "Others"]
  var loadingView: UIView = UIView()
//  let optionsString: [String] = ["Recently Posted", "Expire Soon", "Posts You Might Like", "Job Map"]
  var optionsString: [String]?

  
  //MARK: IBOutlets
  
  @IBOutlet weak var locationButton: UIButton!
  @IBOutlet weak var latestCollectionView: UICollectionView!
  @IBOutlet weak var bannerView: GADBannerView!
  @IBOutlet weak var categoryCollectionView: UICollectionView!
  @IBOutlet weak var optionTableView: UITableView!
  @IBOutlet weak var optionView: UIView!
  @IBOutlet var tableViewHeight: NSLayoutConstraint!
  
  //MARK: UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    optionsString = ["Recently Posted", "Starred Posts", "Jobs Posted By You"]
    if let optionsString = optionsString {
      tableViewHeight.constant = CGFloat(40 * optionsString.count)
    }else {
      optionView.isHidden = true
      optionTableView.isHidden = true
    }
    fetchDataFromDB()
    var keys: NSDictionary?
    if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }
    if let dict = keys {
      let gaAPI = dict["googleBanner"] as? String
      print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
      bannerView.adUnitID = gaAPI!
      //      bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // TEST
      bannerView.rootViewController = self
      bannerView.load(GADRequest())
    }
    self.setUpLocationForButton(locationButton)
    self.startTimer()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.setUpLocationForButton(locationButton)
    
    let nav = self.navigationController?.navigationBar
    nav?.barTintColor = UIColor.init(red: 255.0/255.0, green: 121.0/255.0, blue: 121.0/255.0, alpha: 1.0)
    
    let attrs = [
      NSForegroundColorAttributeName: UIColor.white,
      NSFontAttributeName: UIFont(name: "Futura-MediumItalic", size: 25)!
    ]
    
    nav?.titleTextAttributes = attrs
    
    self.tabBarController?.tabBar.barTintColor = UIColor.init(red: 56.0/255.0, green: 61.0/255.0, blue: 59.0/255.0, alpha: 0.2)
    self.tabBarController?.tabBar.tintColor = UIColor.white
    self.setUpLocationForButton(locationButton)
    
    //    fetchDataFromDB()
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
      let cellHeight = 150
      return CGSize.init(width:collectionView.bounds.size.width, height:CGFloat(cellHeight))
    }else{
      let cellHeight = 100
      return CGSize.init(width:CGFloat(cellHeight), height:CGFloat(cellHeight))
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
    if scrollView == latestCollectionView{
      let contentOffsetScrolledRight: Float = Float(self.latestCollectionView.frame.size.width) * Float(self.latestContents.count - 1)
      
      if Float(scrollView.contentOffset.x) == contentOffsetScrolledRight{
        let newIndexPath: IndexPath = IndexPath.init(item: 1, section: 0)
        
        self.latestCollectionView.scrollToItem(at: newIndexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
      }else if scrollView.contentOffset.x == 0 {
        let newIndexPath: IndexPath = IndexPath.init(item: (self.latestContents.count - 2), section: 0)
        
        self.latestCollectionView.scrollToItem(at: newIndexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
      }
    }
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    
    if scrollView == latestCollectionView{
      let contentOffsetScrolledRight: Float = Float(self.latestCollectionView.frame.size.width) * Float(self.latestContents.count - 1)
      
      if Float(scrollView.contentOffset.x) == contentOffsetScrolledRight{
        let newIndexPath: IndexPath = IndexPath.init(item: 1, section: 0)
        
        self.latestCollectionView.scrollToItem(at: newIndexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
      }else if scrollView.contentOffset.x == 0 {
        let newIndexPath: IndexPath = IndexPath.init(item: (self.latestContents.count - 2), section: 0)
        
        self.latestCollectionView.scrollToItem(at: newIndexPath as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
      }
    }
  }
  
  //MARK: TableView
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let optionsString = optionsString else { return 0 }
    return optionsString.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath)
    cell.textLabel?.text = self.optionsString?[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
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
          let controller = segue.destination as! TableViewController
          controller.contents = categoryContent
        }
      case "optionShow":
        let cell = sender as! UITableViewCell
        if let indexPath = self.optionTableView!.indexPath(for: cell){
          guard let optionsString = self.optionsString else { break }
          var optionContent = optionsString[indexPath.row]
          if optionContent == "Starred Posts" {
            optionContent = "myFavorites"
          }else if optionContent == "Jobs Posted By You" {
            optionContent = "myPosts"
          }
          let controller = segue.destination as! TableViewController
          controller.contents = optionContent
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
  func scrollToNextCell(){
    let collectionView = latestCollectionView
    //get cell size
    let cellSize = CGSize.init(width: self.view.frame.width - 20, height: self.view.frame.height)
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
      ref.child("All").queryOrdered(byChild: "date").queryLimited(toFirst: 5).observe(.value, with: { snapshot in
        var latestItems: [JobItem] = []
        for item in snapshot.children {
          let jobItem = JobItem(snapshot: item as! DataSnapshot)
          self.itemCounter += 1
          let readableOrigin: String = (UserDefaults.standard.string(forKey: "currentLocation"))!
          let userDistanceRequest = UserDefaults.standard.integer(forKey: "searchDistance")
          let readableDestination: String = jobItem.location
          let readableDistanceRequest = userDistanceRequest * 1000
          
                    //                latestItems = latestItems.sorted(by: {$0.date.compare($1.date) == ComparisonResult.orderedDescending})
          
          HippoApiManager.shared.getDistance(origin: readableOrigin, destination: readableDestination, completion: { result in
            switch result {
            case .failure(_):
              self.areaNotAvailable()
            case .success(let distance):
              let distanceKm = distance!.distance
              if distanceKm > Double(readableDistanceRequest){
                self.rejectionCounter += 1
                if self.rejectionCounter == self.itemCounter{
                  self.noJobsFound()
                }
              }else {
                latestItems.append(jobItem)
                
                let availablePosts = snapshot.children.allObjects.count - self.rejectionCounter
                if latestItems.count == availablePosts {
                  let firstItem = latestItems.first
                  let lastItem = latestItems.last
                  
                  latestItems.append(firstItem!)
                  latestItems.insert(lastItem!, at: 0)
                  
                  self.latestContents = latestItems
                  self.latestCollectionView.reloadData()
                  
                  let indexToScrollTo = IndexPath.init(item: 1, section: 0)
                  self.latestCollectionView.scrollToItem(at: indexToScrollTo as IndexPath, at: UICollectionViewScrollPosition.left, animated: false)
                }
              }
            }
          })
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
      self.currentLocationNeeded()
    }
  }
}
