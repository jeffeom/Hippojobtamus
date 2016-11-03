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

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var commentsLabel: UITextView!
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var detailItem: JobItem = JobItem.init(title: "", category: [""], comments: "", photo: "", addedByUser: "", date: "", location: "")
    
    let screenSize: CGRect = UIScreen.main.bounds
    var latitude: Double = 0
    var longitude: Double = 0
    var newImageView = UIImageView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.getImageFromString(string: (self.detailItem.photo))
        self.dateLabel.text = "  " + self.detailItem.date
        self.locationLabel.text = "  " + self.detailItem.location
        self.commentsLabel.text = "  " + self.detailItem.comments
        self.title = self.detailItem.title
        
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
        
        let readableAddress = self.detailItem.location.replacingOccurrences(of: " ", with: "")
        self.fetchLatLong(address: readableAddress) { (fetchedAddress) in
            
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(sender:)))
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
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
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
    
    //MARK: Function
    
    func getImageFromString(string: String) -> UIImage {
        let data: NSData = NSData.init(base64Encoded: string, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        let image: UIImage = UIImage.init(data: data as Data)!
        
        return image
    }
    
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        
        sender.view?.removeFromSuperview()
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}

