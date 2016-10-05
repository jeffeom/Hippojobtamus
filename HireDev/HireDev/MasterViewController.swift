//
//  MasterViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-08.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import Firebase
import FontAwesome_swift

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    
    //MARK: Properties
    
    var contents = ""
    var categoryContents = [JobItem]()
    var indicator = UIActivityIndicatorView()
    let ref = FIRDatabase.database().reference(withPath: "job-post")
    
    //MARK: UITableView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = contents
        indicator.color = UIColor.gray
        indicator.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        indicator.center = CGPoint.init(x: self.view.frame.midX, y: self.view.frame.height / 10)
        self.view.addSubview(indicator)
        indicator.bringSubview(toFront: self.view)
        indicator.startAnimating()
        
        self.ref.child(contents).observe(.value, with: { (snapshot) in
            var newItems: [JobItem] = []
            
            for item in snapshot.children {
                let jobItem = JobItem(snapshot: item as! FIRDataSnapshot)
                
                let readableOrigin: String = (UserDefaults.standard.string(forKey: "currentLocation")?.replacingOccurrences(of: " ", with: ""))!
                let readableDestination: String = jobItem.location.replacingOccurrences(of: " ", with: "")
                
                self.checkDistance(origin: readableOrigin, destination: readableDestination) { (fetchedData) in
                    DispatchQueue.main.async {
                        
                        let userDistanceRequest = UserDefaults.standard.integer(forKey: "searchDistance")
                        let readableDistanceRequest = userDistanceRequest * 1000
                        
                        if let aDistance = fetchedData?.first{
                            NSLog("Measure Found")
                            if aDistance > Float(readableDistanceRequest){
                                NSLog("Reject Found. Too far")
                            }else{
                                newItems.append(jobItem)
                                NSLog("Add In")
                                self.categoryContents = newItems
                                self.tableView.reloadData()
                            }
                        }else{
                            NSLog("Error, no measuredDistance found")
                        }
                    }
                    NSLog("End of check")
                }
            }
            
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        })
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let categoryContent = self.categoryContents[(indexPath as NSIndexPath).row]
                let controller = segue.destination as! DetailViewController
                controller.detailItem = categoryContent as JobItem
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryContents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! JobTableViewCell
        
        if (categoryContents.count != 0) {
            let categoryContents = self.categoryContents[(indexPath as NSIndexPath).row]
            cell.titleLabel!.text = categoryContents.title
            cell.commentsLabel.text = categoryContents.date
            cell.myImageView.image = self.getImageFromString(string: categoryContents.photo)
            cell.locationLabel.text = categoryContents.location
        }else{
            NSLog("categoryContents is empty")
        }
        
        return cell
    }
    
    func getImageFromString(string: String) -> UIImage {
        let data: NSData = NSData.init(base64Encoded: string, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        let image: UIImage = UIImage.init(data: data as Data)!
        
        return image
    }
}

