//
//  ViewController+KeyboardDismiss.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-12.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
