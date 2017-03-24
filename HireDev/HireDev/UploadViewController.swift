//
//  UploadViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-22.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import MobileCoreServices
import FontAwesome_swift
import FirebaseDatabase
import Firebase

class UploadViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // MARK: IBOutlets
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var commentsField: UITextView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var seeMore: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    // MARK: Properties
    
    let jobref = FIRDatabase.database().reference(withPath: "job-post")
    let userRef = FIRDatabase.database().reference(withPath: "users")
    var savedJobs: [JobItem] = []
    let category: [String] = ["Cafe", "Restaurant", "Grocery", "Bank", "Education", "Sales", "Receptionist", "Others"]
    var hidden: Bool = true
    var selectedIndexPath: IndexPath = IndexPath()
    var checked: [Bool] = [false, false, false, false, false, false, false, false]
    var newMedia: Bool?
    var imageData: Data = Data()
    var imageString: String = ""
    var placeholderLabel : UILabel!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let dict = keys {
            let gaAPI = dict["googleBanner"] as? String
            
            //            bannerView.adUnitID = gaAPI!
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // TEST
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        
        self.myTableView.isHidden = hidden
        
        commentsField.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Optional"
        placeholderLabel.font = UIFont.systemFont(ofSize: (commentsField.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        commentsField.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint.init(x: 5, y: (commentsField.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.25)
        placeholderLabel.isHidden = !commentsField.text.isEmpty
        
        self.setUpLocationForLabel(locationLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor.init(red: 255.0/255.0, green: 121.0/255.0, blue: 121.0/255.0, alpha: 1.0)
        nav?.isTranslucent = false
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        nav?.tintColor = UIColor.white
        
        self.setUpLocationForLabel(locationLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    // MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.myTableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = category[indexPath.row]
        
        if !checked[indexPath.row] {
            cell.accessoryType = .none
        } else if checked[indexPath.row] {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                checked[indexPath.row] = false
            } else {
                cell.accessoryType = .checkmark
                checked[indexPath.row] = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.tintColor = UIColor.blue
        cell.backgroundColor = UIColor.clear
    }
    
    //MARK: Photo
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            photoView.image = image
            photoView.contentMode = .scaleAspectFit
            imageData = UIImageJPEGRepresentation(image, 0.1)! as Data
            imageString = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
            self.photoButton.setTitle("Tap again to retake", for: .normal)
            
            // Saves to Library
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if let _ = error {
            showAlert("Failed to save image", title: "Save Failed", fn: {
                return
            })
        }else{
            showAlert("Your photo is saved successfully", title: "Saved to Device", fn: {
                self.photoButton.setTitle("Tap again to retake", for: .normal)
                return
            })
        }
    }
    
    //MARK: Action Button
    
    @IBAction func showTableView(_ sender: AnyObject) {
        if hidden == true{
            UIView.animate(withDuration: 0.2) {
                self.myTableView.isHidden = false
            }
            hidden = false
            self.loadViewIfNeeded()
            seeMore.text = "Less"
        }else{
            UIView.animate(withDuration: 0.2) {
                self.myTableView.isHidden = true
            }
            hidden = true
            self.loadViewIfNeeded()
            seeMore.text = "Tap to see more"
        }
    }
    
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Photo", message: "Please choose to take a photo or to use a photo from your photo library", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            
            // Camera
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                imagePicker.modalPresentationStyle = .popover
                self.present(imagePicker, animated: true, completion: nil)
                self.newMedia = true
            }else{
                let alert = UIAlertController(title: "Error", message: "I am sorry, but your phone seems to have a problem with the Camera", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            
            // Library
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction) in
            return
        }))
        
        alert.show()
    }
    
    @IBAction func submitButton(_ sender: AnyObject) {
        let selectedCategory: [String] = chosenCategory(checked)
        
        if (check() && selectedCategory.count != 1 && (UserDefaults.standard.string(forKey: "currentLocation") != nil)){
            self.loadViewIfNeeded()
            let alert = UIAlertController(title: "Thank You!", message: "Job is posted. Fellow Hippos will appreciate your work " + "❤️", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true) {
                let currentDate = self.getCurrentDate()
                let timeStamp = self.getTimeStamp()
                let jobItem = JobItem(title: self.titleField.text!, category: selectedCategory, comments: self.commentsField.text, photo: self.imageString, addedByUser: (UserDefaults.standard.object(forKey: "email") as? String)!, date: currentDate, location: self.locationLabel.text!)
                self.savedJobs.append(jobItem)
                
                for aCategory in selectedCategory{
                    let jobId = "\(timeStamp)"+"\(self.titleField.text!)"
                    
                    let jobItemRef = self.jobref.child(aCategory).child(jobId)
                    jobItemRef.setValue(jobItem.toAnyObject())
                    
                    let userRef = self.userRef.child((FIRAuth.auth()!.currentUser!.email?.replacingOccurrences(of: ".", with: ""))!)
                    
                    userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let postSnapshot = snapshot.childSnapshot(forPath: "uploadedPosts").value {
                            var uploadedPosts: [String] = postSnapshot as! [String]
                            
                            if uploadedPosts[0] == "" {
                                uploadedPosts[0] = jobId
                                userRef.updateChildValues([
                                    "uploadedPosts": uploadedPosts
                                ])
                            }else{
                                uploadedPosts.append(jobId)
                                userRef.updateChildValues([
                                    "uploadedPosts": uploadedPosts
                                ])
                            }
                        }
                    })
                }
                self.reset()
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "Sorry, I think you left one of the fields empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Function
    
    func chosenCategory (_ array: [Bool]) -> [String] {
        var chosenCategory: [String] = Array()
        for (pos, aCheck) in array.enumerated(){
            if aCheck == true{
                chosenCategory.append(category[pos])
            }
        }
        chosenCategory.append("All")
        return chosenCategory
    }
    
    // MARK: Check
    
    func check() -> Bool {
        if let _ = titleField.text, !imageString.isEmpty {
            return true
        }
        else{
            return false
        }
    }
    
    // MARK: Reset
    
    func reset() {
        titleField.text = ""
        commentsField.text = ""
        placeholderLabel.isHidden = !commentsField.text.isEmpty
        photoView.image = UIImage.init(named: "upload_box")
        checked = [false, false, false, false, false, false, false, false]
        photoButton.setTitle("Tap here to take a photo", for: .normal)
        imageString = ""
        myTableView.reloadData()
    }
    
    @IBAction func resetButton(_ sender: AnyObject) {
        reset()
    }
    
    @IBAction func locationSetting(_ sender: AnyObject) {
        let locationSettingController = self.storyboard?.instantiateViewController(withIdentifier: "locationSetting")
        self.navigationController?.pushViewController(locationSettingController!
            , animated: true)
    }
    
    // MARK: dateToString
    
    func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date as Date)
        
        return dateString
    }
    
    func getTimeStamp() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddHHmm"
        let dateString = dateFormatter.string(from: date as Date)
        
        return dateString
    }
}
