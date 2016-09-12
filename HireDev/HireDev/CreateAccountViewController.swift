//
//  CreateAccountViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-09.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBAction func cancelClicked(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
