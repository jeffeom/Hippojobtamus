//
//  ViewController+PhotoDownload.swift
//  Hippo
//
//  Created by Jeff Eom on 2017-06-16.
//  Copyright © 2017 Jeff Eom. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import SwiftSpinner

extension UIViewController {
  func uploadPhoto(to dbString: String, with imageData: Data, completion: @escaping () -> Void) {
    let storageRef = Storage.storage().reference()
    let imageRef = storageRef.child("post-images").child(dbString)
    let spaceRef = imageRef.child("0")
    let uploadTask = spaceRef.putData(imageData, metadata: nil)
    uploadTask.resume()
    
    uploadTask.observe(.progress) { snapshot in
      // Upload reported progress
      let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
        / Double(snapshot.progress!.totalUnitCount)
      let percentString = "Uploading: " + String(format: "%.0f", percentComplete) + "%"
      SwiftSpinner.show(percentString)
      print(percentString)
    }
    
    uploadTask.observe(.success) { snapshot in
      SwiftSpinner.hide({
        SwiftSpinner.show(duration: 2, title: "Image Upload Completed")
        completion()
      })
    }
    uploadTask.observe(.failure) { snapshot in
      if let error = snapshot.error as NSError? {
        SwiftSpinner.hide({
          SwiftSpinner.show(duration: 2, title: error.localizedDescription)
          completion()
        })
      }
    }
  }
  
  func downloadPhoto(from jobItem: JobItem, to imageView: UIImageView){
    let storageRef: StorageReference = Storage.storage().reference(withPath: "post-images")
    guard let dbTitle = jobItem.ref?.key else { return }
    let imageRef = storageRef.child(dbTitle).child("0")
    print(dbTitle)
    
    imageRef.downloadURL { url, error in
      guard error == nil else { return }
      imageView.sd_setImage(with: url)
    }
  }
}
