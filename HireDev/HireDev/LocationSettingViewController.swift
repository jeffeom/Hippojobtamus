//
//  LocationSettingViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-10-01.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class LocationSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
