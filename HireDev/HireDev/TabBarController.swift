//
//  TabBarController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-24.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let homeTabImage = UIImage.fontAwesomeIcon(.home, textColor: UIColor.black, size: CGSize.init(width: 35, height: 35))
        let addTabImage = UIImage.fontAwesomeIcon(.plusCircle, textColor: UIColor.black, size: CGSize.init(width: 35, height: 35))
        let settingTabImage = UIImage.fontAwesomeIcon(.cog, textColor: UIColor.black, size: CGSize.init(width: 35, height: 35))
        
        self.viewControllers?[0].tabBarItem = UITabBarItem(title: "Home", image: homeTabImage, selectedImage: homeTabImage)
        self.viewControllers?[1].tabBarItem = UITabBarItem(title: "Upload", image: addTabImage, selectedImage: addTabImage)
        self.viewControllers?[2].tabBarItem = UITabBarItem(title: "Setting", image: settingTabImage, selectedImage: settingTabImage)
    }
}
