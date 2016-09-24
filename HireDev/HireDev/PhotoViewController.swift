//
//  PhotoViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-22.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let cameraAlert: UIAlertController = UIAlertController.init(title: "Error", message: "Seems like you do not have Camera installed in the device", preferredStyle: UIAlertControllerStyle.alert)
//            
//            let myAlertAction: UIAlertAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
//            
//            cameraAlert.addAction(myAlertAction)
//            
//            self.present(cameraAlert, animated: true, completion: nil)
//        }else{
//            self.allowsEditing = false
//            self.sourceType = .camera
//            self.cameraCaptureMode = .photo
//            self.modalPresentationStyle = .fullScreen
//            self.present(self,animated: true,completion: nil)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    //MARK: - Delegates
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [String : AnyObject])
//    {
//        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
//        myImageView.contentMode = .scaleAspectFit //3
//        myImageView.image = chosenImage //4
//        dismiss(animated:true, completion: nil) //5
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
