//
//  JobItem.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-26.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct JobItem{
    
    let key: String
    let title: String
    let category: [String]
    let comments: String
    let photo: String
    let ref: FIRDatabaseReference?
    
    init(title: String, category: [String], comments: String, photo: String, key: String = "") {
        self.key = key
        self.title = title
        self.category = category
        self.comments = comments
        self.photo = photo
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        category = snapshotValue["category"] as! [String]
        comments = snapshotValue["comments"] as! String
        photo = snapshotValue["photo"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "category": category,
            "comments": comments,
            "photo": photo
        ]
    }
    

}
