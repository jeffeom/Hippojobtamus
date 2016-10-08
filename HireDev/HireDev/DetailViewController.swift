//
//  DetailViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-08.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var commentsLabel: UITextView!
    
    var detailItem: JobItem = JobItem.init(title: "", category: [""], comments: "", photo: "", addedByUser: "", date: "", location: "")
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.getImageFromString(string: (self.detailItem.photo))
        self.dateLabel.text = "  " + self.detailItem.date
        self.locationLabel.text = "  " + self.detailItem.location
        self.commentsLabel.text = "  " + self.detailItem.comments
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = self.detailItem.title
        
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
    
    //MARK: Function
    
    func getImageFromString(string: String) -> UIImage {
        let data: NSData = NSData.init(base64Encoded: string, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        let image: UIImage = UIImage.init(data: data as Data)!
        
        return image
    }
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        let screenWidth = self.screenSize.width
        let screenHeight = self.screenSize.height
        newImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        newImageView.backgroundColor = UIColor.black
        newImageView.contentMode = .scaleToFill
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(sender:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
        setTabBarVisible(visible: !tabBarIsVisible(), animated: true, completion: {_ in })
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        
        sender.view?.removeFromSuperview()
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
        setTabBarVisible(visible: !tabBarIsVisible(), animated: true, completion: {_ in })
    }
    
    // pass a param to describe the state change, an animated flag and a completion block matching UIView animations completion
    func setTabBarVisible(visible: Bool, animated: Bool, completion:@escaping (Bool)->Void) {
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) {
            return completion(true)
        }
        
        // get a frame calculation ready
        let height = tabBarController!.tabBar.frame.size.height
        let offsetY = (visible ? -height : height)
        
        // zero duration means no animation
        let duration = (animated ? 0.3 : 0.0)
        
        UIView.animate(withDuration: duration, animations: {
            let frame = self.tabBarController!.tabBar.frame
            self.tabBarController!.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY);
            }, completion:completion)
    }
    
    func tabBarIsVisible() -> Bool {
        return tabBarController!.tabBar.frame.origin.y < view.frame.maxY
    }
}

