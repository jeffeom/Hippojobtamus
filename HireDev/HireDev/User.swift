//
//  User.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-10-06.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct User{
    
    let key: String
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    let emailVerify: Bool
    let currentLocation: [Float]
    let searchDistance: Float
    let searchHistory: [String]
    let uploadedPosts: [String]
    let favoredPosts: [String]
    let ref: DatabaseReference?
    
    init(uid: String, firstName: String, lastName: String, email: String, emailVerify: Bool, currentLocation: [Float], searchDistance: Float, searchHistory: [String], uploadedPosts: [String], favoredPosts: [String], key: String = "") {
        self.key = key
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.emailVerify = emailVerify
        self.currentLocation = currentLocation
        self.searchDistance = searchDistance
        self.searchHistory = searchHistory
        self.uploadedPosts = uploadedPosts
        self.favoredPosts = favoredPosts
        
        self.ref = nil
    }
    
    /*
     Users
     - UID
     - FN
     - LN
     - Email
     - Current Location - lat
     - long
     - search Distance
     - search History
     - uploadedPosts
     - favoredPost
     */
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        uid = snapshotValue["uid"] as! String
        firstName = snapshotValue["firstName"] as! String
        lastName = snapshotValue["lastName"] as! String
        email = snapshotValue["email"] as! String
        emailVerify = snapshotValue["emailVerify"] as! Bool
        currentLocation = snapshotValue["currentLocation"] as! [Float]
        searchDistance = snapshotValue["searchDistance"] as! Float
        searchHistory = snapshotValue["searchHistory"] as! [String]
        uploadedPosts = snapshotValue["uploadedPosts"] as! [String]
        favoredPosts = snapshotValue["favoredPosts"] as! [String]
        
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "uid": uid,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "emailVerify": emailVerify,
            "currentLocation": currentLocation,
            "searchDistance": searchDistance,
            "searchHistory": searchHistory,
            "uploadedPosts": uploadedPosts,
            "favoredPosts": favoredPosts
        ]
    }
    
    
}
