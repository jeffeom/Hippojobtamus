//
//  TableViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-08.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import Firebase
import FontAwesome_swift
import SwiftSpinner

class TableViewController: UITableViewController {
  
  //MARK: Properties
  
  var detailViewController: DetailViewController?
  var contents = "" {
    didSet{
      self.title = contents
      SwiftSpinner.show("Loading").addTapHandler({
        SwiftSpinner.hide()
      })
      if contents == "myPosts" {
        self.title = "Posts"
        self.fetchPersonalDB(personalRef: myPostRef, type: contents, completion: {_ in
          if self.postRef.count != 0{
            for aPost in self.postRef{
              self.fetchPersonalDBUsingNames(name: aPost, completion: {_ in
                NSLog("all done")
              })
            }
          }else{
            NSLog("empty!")
            SwiftSpinner.hide()
          }
        })
      }else if contents == "myFavorites"{
        self.title = "Favorites"
        self.fetchPersonalDB(personalRef: myPostRef, type: contents, completion: {_ in
          if self.postRef.count != 0{
            for aPost in self.postRef{
              self.fetchPersonalDBUsingRef(refString: aPost, completion: {_ in
                NSLog("all done")
              })
            }
          }else{
            NSLog("empty!")
            SwiftSpinner.hide()
          }
        })
      }else{
        self.fetchDataFromDB()
      }
    }
  }
  var categoryContents = [JobItem]()
  let jobPostRef = Database.database().reference(withPath: "job-post")
  let myPostRef = Database.database().reference(withPath: "users").child((Auth.auth().currentUser!.email?.replacingOccurrences(of: ".", with: ""))!)
  var newItems: [JobItem] = []
  var postNames: [String] = []
  var postRef: [String] = []
  var rejectionCounter = 0
  var itemCounter = 0
  var readableOrigin: String = ""
  
  //MARK: UITableView
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    let nav = self.navigationController?.navigationBar
    let font = UIFont.boldSystemFont(ofSize: 18)
    nav?.titleTextAttributes = [NSFontAttributeName: font]
    nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    nav?.tintColor = UIColor.white
    self.navigationController?.setNavigationBarHidden(false, animated: true)
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
      let categoryContent = self.categoryContents[(indexPath as NSIndexPath).row]
      cell.titleLabel!.text = categoryContent.title
      cell.commentsLabel.text = categoryContent.date
      self.downloadPhoto(from: categoryContent, to: cell.myImageView)
      cell.locationLabel.text = categoryContent.location
    }
    return cell
  }
  
  func fetchDataFromDB() {
    // use enum case
    if contents == "Recently Posted"{
      contents = "All"
    }else if contents == "Expire Soon"{
      contents = "All"
    }else if contents == "Posts You Might Like"{
      contents = "All"
    }else if contents == "Job Map"{
      contents = "All"
    }
    
    self.jobPostRef.child(contents).observe(.value, with: { (snapshot) in
      var newItems: [JobItem] = []
      guard snapshot.hasChildren() else {
        SwiftSpinner.show(duration: 1, title: "No Post Found")
        return
      }
      for item in snapshot.children {
        self.itemCounter += 1
        let jobItem = JobItem(snapshot: item as! DataSnapshot)
        if let theLocation = UserDefaults.standard.string(forKey: "currentLocation"){
          self.readableOrigin = theLocation
        }else{
          let alert = UIAlertController(title: "Current Location Needed", message: "Please set your current location", preferredStyle: UIAlertControllerStyle.alert)
          alert.addAction(UIAlertAction(title: "Location Settings", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
            self.navigationController?.pushViewController(vc!, animated: true)
          }))
          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
            return
          }))
          SwiftSpinner.hide()
          alert.show()
        }
        let readableDestination: String = jobItem.location
        self.checkDistance(self.readableOrigin, destination: readableDestination) { (fetchedData) in
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
                  SwiftSpinner.hide()
                  alert.show()
                }
              }else{
                newItems.append(jobItem)
                newItems = newItems.sorted(by: {$0.date.compare($1.date) == ComparisonResult.orderedDescending})
                
                self.categoryContents = newItems
                SwiftSpinner.hide()
                self.tableView.reloadData()
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
                SwiftSpinner.hide()
                alert.show()
              }
            }
          }
        }
      }
    })
  }
  
  func fetchPersonalDB(personalRef: DatabaseReference, type: String, completion:@escaping ((_ finished:Bool) -> Void)) {
    // use case
    if type == "myPosts"{
      personalRef.child("uploadedPosts").observe(.value, with: {(snapshot1) in
        
        let snapshotValue = snapshot1.value as! [String]
        
        if snapshotValue.count != 0{
          self.postRef = snapshotValue
        }
        completion(true)
      })
    }else if type == "myFavorites"{
      personalRef.child("favoredPosts").observe(.value, with: {(snapshot1) in
        
        let snapshotValue = snapshot1.value as! [String]
        
        if snapshotValue.count != 0{
          self.postRef = snapshotValue
        }
        completion(true)
      })
    }
    SwiftSpinner.hide()
  }
  
  func fetchPersonalDBUsingNames(name: String, completion: @escaping ((_ finished: Bool) -> Void)) {
    if name != ""{
      self.newItems = []
      self.jobPostRef.child("All").child(name).observe(.value, with: {(snapshot2) in
        
        let snapshotValue = snapshot2.value as! [String: AnyObject]
        
        let myJob: JobItem = JobItem.init(title: snapshotValue["title"] as! String, category: snapshotValue["category"] as! [String], comments: snapshotValue["comments"] as! String, addedByUser: snapshotValue["addedByUser"] as! String, date: snapshotValue["date"] as! String, location: snapshotValue["location"] as! String, ref: self.jobPostRef.child("All").child(name))
        
        let jobItem = myJob
        self.newItems.append(jobItem)
        
        self.categoryContents = self.newItems
        self.tableView.reloadData()
        completion(true)
      })
    }
    SwiftSpinner.hide()
  }
  
  func fetchPersonalDBUsingRef(refString: String, completion: @escaping ((_ finished: Bool) -> Void)){
    if refString != ""{
      self.newItems = []
      let ref: DatabaseReference = Database.database().reference(fromURL: refString)
      ref.observeSingleEvent(of: .value, with: {(snapshot) in
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else { return }
        let myJob: JobItem = JobItem.init(title: snapshotValue["title"] as! String, category: snapshotValue["category"] as! [String], comments: snapshotValue["comments"] as! String, addedByUser: snapshotValue["addedByUser"] as! String, date: snapshotValue["date"] as! String, location: snapshotValue["location"] as! String, ref: ref)
        let jobItem = myJob
        self.newItems.append(jobItem)
        
        self.categoryContents = self.newItems
        self.tableView.reloadData()
        completion(true)
      })
    }
    SwiftSpinner.hide()
  }
}

