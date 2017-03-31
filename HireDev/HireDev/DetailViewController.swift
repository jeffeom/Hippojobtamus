//
//  DetailViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-08.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMobileAds
import Firebase

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationLabel2: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var commentsLabel: UITextView!
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var descriptionSV: UIStackView!
    @IBOutlet weak var photosView: UIView!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var segmentedControl: SegmentedControl!
    
    var detailItem: JobItem = JobItem.init(title: "", category: [""], comments: "", photo: "", addedByUser: "", date: "", location: "")
    let screenSize: CGRect = UIScreen.main.bounds
    var latitude: Double = 0
    var longitude: Double = 0
    var newImageView = UIImageView.init()
    var jobTitle: String?
    var jobRef: String?
    let userRef: FIRDatabaseReference = FIRDatabase.database().reference(withPath: "users").child((UserDefaults.standard.string(forKey: "email")?.replacingOccurrences(of: ".", with: ""))!)
    var favoredPosts: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        self.imageView.image = self.getImageFromString((self.detailItem.photo))
    
        self.titleLabel.text = detailItem.title
        self.titleLabel2.text = detailItem.title
        self.dateLabel.text = "     " + self.detailItem.date
        self.locationLabel.text = "  " + self.detailItem.location
        self.locationLabel2.text = "     " + self.detailItem.location
        self.commentsLabel.text = "    " + self.detailItem.comments
        self.title = ""
    
        jobTitle = detailItem.title
        jobRef = detailItem.ref?.description()
        
        self.photosView.layer.cornerRadius = 20
        self.overView.layer.cornerRadius = 20
        self.mapView.layer.cornerRadius = 20
        
        photosView.isHidden = false
        overView.isHidden = true
        mapView.isHidden = true
        
        self.userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childSnapshot(forPath: "favoredPosts").exists(){
                self.favoredPosts = snapshot.childSnapshot(forPath: "favoredPosts").value! as! [String]
            }else{
                self.favoredPosts = [""]
                self.userRef.child("favoredPosts").setValue(self.favoredPosts)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        if self.detailItem.comments == ""{
            self.descriptionSV.isHidden = true
        }
        
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let dict = keys {
            let gaAPI = dict["googleBanner"] as? String
            
            print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
            //            bannerView.adUnitID = gaAPI!
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // TEST
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        
        let readableAddress = self.detailItem.location.replacingOccurrences(of: " ", with: "")
        self.fetchLatLong(readableAddress) { (fetchedAddress) in
            
            if let lat = fetchedAddress?["lat"], let long = fetchedAddress?["lng"]{
                if (lat != 0 && long != 0){
                    DispatchQueue.main.sync{
                        let camera = GMSCameraPosition.camera(withLatitude: Double(lat), longitude: Double(long), zoom: 15)
                        self.googleMap.isMyLocationEnabled = true
                        self.googleMap.camera = camera
                        
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2DMake(Double(lat), Double(long))
                        marker.title = self.detailItem.title
                        marker.snippet = self.detailItem.location
                        marker.map = self.googleMap
                        
                        self.latitude = Double(lat)
                        self.longitude = Double(long)
                    }
                }else{
                    NSLog("not yet")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        let font = UIFont.boldSystemFont(ofSize: 18)
        nav?.titleTextAttributes = [NSFontAttributeName: font]
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        nav?.tintColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction
    
    @IBAction func optionValueChanged(_ sender: SegmentedControl) {
        
        let selectedIndex = sender.selectedIndex
        
        switch selectedIndex {
        case 0:
            NSLog("Photo")
            photosView.isHidden = false
            overView.isHidden = true
            mapView.isHidden = true
        case 1:
            NSLog("Overview")
            photosView.isHidden = true
            overView.isHidden = false
            mapView.isHidden = true
        case 2:
            NSLog("Map")
            photosView.isHidden = true
            overView.isHidden = true
            mapView.isHidden = false
        default:
            break
        }
        
    }
    
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height + (self.navigationController?.navigationBar.frame.height)! + (self.tabBarController?.tabBar.frame.height)!
        
        let scrollImg: UIScrollView = UIScrollView()
        scrollImg.isUserInteractionEnabled = true
        scrollImg.delegate = self
        scrollImg.frame = CGRect.init(x: 0, y: 0, width: vWidth, height: vHeight)
        scrollImg.backgroundColor = UIColor.black
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 10.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        scrollImg.addGestureRecognizer(tap)
        self.view.addSubview(scrollImg)
        
        let imageView = sender.view as! UIImageView
        newImageView = UIImageView(image: imageView.image)
        let screenWidth = self.screenSize.width
        let screenHeight = self.screenSize.height
        newImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        newImageView.backgroundColor = UIColor.black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        scrollImg.addSubview(newImageView)
        
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.newImageView
    }
    
    @IBAction func toGoogleMap(_ sender: AnyObject) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")! as URL)) {
            if let url = URL(string: "comgooglemaps://?center=\(self.latitude),\(self.longitude)&zoom=14&views=traffic"){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        } else {
            print("Can't use comgooglemaps://");
        }
        
    }

    @IBAction func favoriteMark(_ sender: Any) {
        NSLog("favorite clicked, \(jobTitle), \(jobRef)")
        
        if self.checkForSameData(favoredPosts, string: jobRef!){
            // if no samedata
            self.favorite()
            
        }else{
            // if there are samedata
            self.unfavorite()
        }
        
    }
    //MARK: SwipeGesture
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                // back
                
                let animation = CATransition.init()
                animation.duration = 0.5
                animation.type = kCATransitionPush
                animation.subtype = kCATransitionFromLeft
                animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
                
                switch segmentedControl.selectedIndex {
                case 0:
                    
                    NSLog("Map")
                    photosView.isHidden = true
                    overView.isHidden = true
                    mapView.isHidden = false
                    segmentedControl.selectedIndex = 2
                    
                    mapView.layer.add(animation, forKey: "showSecondView")

                case 1:
                    NSLog("Photo")
                    photosView.isHidden = false
                    overView.isHidden = true
                    mapView.isHidden = true
                    segmentedControl.selectedIndex = 0
                    
                    photosView.layer.add(animation, forKey: "showSecondView")

                case 2:
                    NSLog("Overview")
                    photosView.isHidden = true
                    overView.isHidden = false
                    mapView.isHidden = true
                    segmentedControl.selectedIndex = 1
                    
                    overView.layer.add(animation, forKey: "showSecondView")
                    
                default:
                    break
                }
                
            case UISwipeGestureRecognizerDirection.left:
                // next
                
                let animation = CATransition.init()
                animation.duration = 0.5
                animation.type = kCATransitionPush
                animation.subtype = kCATransitionFromRight
                animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
                
                switch segmentedControl.selectedIndex {
                case 0:
                    NSLog("Overview")
                    photosView.isHidden = true
                    overView.isHidden = false
                    mapView.isHidden = true
                    segmentedControl.selectedIndex = 1
                    
                    overView.layer.add(animation, forKey: "showSecondView")
                    
                case 1:
                    NSLog("Map")
                    photosView.isHidden = true
                    overView.isHidden = true
                    mapView.isHidden = false
                    segmentedControl.selectedIndex = 2
                    
                    mapView.layer.add(animation, forKey: "showSecondView")
                    
                case 2:
                    NSLog("Photo")
                    photosView.isHidden = false
                    overView.isHidden = true
                    mapView.isHidden = true
                    segmentedControl.selectedIndex = 0
                    
                    photosView.layer.add(animation, forKey: "showSecondView")
                
                default:
                    break
                }
            default:
                break
            }
        }
    }
    
    //MARK: Function
    
    func getImageFromString(_ string: String) -> UIImage {
        let data: Data = Data.init(base64Encoded: string, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        var image: UIImage = UIImage.init(data: data as Data)!
        
        image = self.setProfileImage(image, onImageView: self.imageView)
        
        return image
    }
    
    func setProfileImage(_ imageToResize: UIImage, onImageView: UIImageView) -> UIImage
    {
        let width = imageToResize.size.width
        let height = imageToResize.size.height
        
        var scaleFactor: CGFloat
        
        if(width > height)
        {
            scaleFactor = onImageView.frame.size.height / height;
        }
        else
        {
            scaleFactor = onImageView.frame.size.width / width;
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        imageToResize.draw(in: CGRect.init(x: 0, y: 0, width: width * scaleFactor, height: height * scaleFactor))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        
        sender.view?.removeFromSuperview()
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
    }
    
    func checkForSameData(_ array: [String], string: String) -> Bool{
        var boolValue: Bool = false
        var count: Int = 0
        
        // if the array is empty
        if favoredPosts.count == 0{
            self.favoredPosts[0] = string
            self.userRef.child("favoredPosts").setValue(self.favoredPosts)
            boolValue = true
        
        // if array has nothing in it
        }else if (favoredPosts.count == 1 && favoredPosts[0] == ""){
            self.favoredPosts[0] = string
            self.userRef.child("favoredPosts").setValue(self.favoredPosts)
            boolValue = true
        
        // if array has subarrays in it
        }else{
            // check every subarrays one by one
            for aSub in array{
                // if subarray matches the string
                if string == aSub{
                    // mark "found"
                    boolValue = false
                    
                    // if it has only 1 subarray
                    if favoredPosts.count == 1{
                        // unfavorite the subarray and erase it
                        favoredPosts[0] = ""
                    }else{
                        // if it has more than subarray delete at count
                        favoredPosts.remove(at: count)
                    }
                // if not found jump to the next subarray
                }else{
                    
                    count += 1
                    
                    // if it checked all of the sub arrays, mark "not found"
                    if count == array.count{
                        
                        // append into the favored list
                        boolValue = true
                        favoredPosts.append(string)

                    }
                }
            }
        }
        
        return boolValue
    }
    
    
    func favorite(){
        self.showAlert("Successfully favored the post!", title: "Favorited", fn: {
            self.userRef.child("favoredPosts").setValue(self.favoredPosts)
        })
    }
    
    func unfavorite(){
        self.showAlert("Successfully unfavored the post!", title: "Unfavorited", fn: {
            self.userRef.child("favoredPosts").setValue(self.favoredPosts)
        })
    }
    
}
