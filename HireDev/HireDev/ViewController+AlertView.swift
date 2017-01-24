//
//  ViewController+AlertView.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-27.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

extension UIViewController{
    func showAlert(_ text : NSString, title : NSString, fn:@escaping ()->Void){
        let alert = UIAlertController(title: title as String, message: text as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in fn()}))
        alert.show()
    }
}
