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
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var seeMore: UILabel!
    
    
    // MARK: Properties
    
    let ref = FIRDatabase.database().reference(withPath: "job-post")
    var savedJobs: [JobItem] = []
    let category: [String] = ["Cafe", "Server", "Tutor", "Sales", "Reception", "Grocery", "Bank", "Others"]
    var hidden: Bool = true
    var selectedIndexPath: IndexPath = IndexPath()
    var checked: [Bool] = [false, false, false, false, false, false, false, false]
    var newMedia: Bool?
    let heartShape: String = String.fontAwesomeIconWithName(FontAwesome.Heart)
    var imageData: NSData = NSData()
    var imageString: String = ""
    var placeholderLabel : UILabel!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHeight.constant = 1050
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    
    //MARK: Photo
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            photoView.image = image
            imageData = UIImageJPEGRepresentation(image, 0.1)! as NSData
            imageString = imageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
            self.photoButton.setTitle("", for: .normal)
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if let _ = error {
            showAlert(text: "Failed to save image", title: "Save Failed", fn: {
                return
            })
        }else{
            showAlert(text: "Your photo is saved successfully", title: "Saved to Device", fn: {
                self.photoButton.setTitle("", for: .normal)
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
            viewHeight.constant = 1190
            self.loadViewIfNeeded()
            seeMore.text = "Less"
        }else{
            UIView.animate(withDuration: 0.2) {
                self.myTableView.isHidden = true
            }
            hidden = true
            viewHeight.constant = 1050
            self.loadViewIfNeeded()
            seeMore.text = "Tab to see more"
        }
    }
    
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            imagePicker.modalPresentationStyle = .popover
            self.present(imagePicker, animated: true, completion: nil)
            newMedia = true
        }else{
            let alert = UIAlertController(title: "Error", message: "I am sorry, but your phone seems to have a problem with the Camera", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func submitButton(_ sender: AnyObject) {
        let selectedCategory: [String] = chosenCategory(array: checked)
        
        NSLog("I checked: \(selectedCategory.count) of category and they are \(selectedCategory.description)")
        
        if (check() && selectedCategory.count != 1){
            let alert = UIAlertController(title: "Thank You!", message: "Job is posted. Fellow Hippos will appreciate your work " + "❤️", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true) {
                let currentDate = self.getCurrentDate()
                let jobItem = JobItem(title: self.titleField.text!, category: selectedCategory, comments: self.commentsField.text, photo: self.imageString, addedByUser: (UserDefaults.standard.object(forKey: "email") as? String)!, date: currentDate)
                self.savedJobs.append(jobItem)
                
                for aCategory in selectedCategory{
                    let jobItemRef = self.ref.child(aCategory).child((self.titleField.text?.lowercased())!)
                    jobItemRef.setValue(jobItem.toAnyObject())
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
    
    func chosenCategory (array: [Bool]) -> [String] {
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
        commentsField.text = "Optional"
        photoView.image = UIImage.init(named: "upload_box")
        checked = [false, false, false, false, false, false, false, false]
        imageString = ""
        myTableView.reloadData()
    }
    
    // MARK: dateToString
    
    func getCurrentDate() -> String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date as Date)
        
        return dateString
    }
    
}
