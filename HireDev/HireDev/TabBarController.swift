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
        
        let homeTabImage = UIImage.fontAwesomeIconWithName(.Home, textColor: UIColor.black, size: CGSize.init(width: 40, height: 40))
        let addTabImage = UIImage.fontAwesomeIconWithName(.PlusCircle, textColor: UIColor.black, size: CGSize.init(width: 40, height: 40))
        let settingTabImage = UIImage.fontAwesomeIconWithName(.Cog, textColor: UIColor.black, size: CGSize.init(width: 40, height: 40))
        
        self.viewControllers?[0].tabBarItem = UITabBarItem(title: "Home", image: homeTabImage, selectedImage: homeTabImage)
        self.viewControllers?[1].tabBarItem = UITabBarItem(title: "Upload", image: addTabImage, selectedImage: addTabImage)
        self.viewControllers?[2].tabBarItem = UITabBarItem(title: "Setting", image: settingTabImage, selectedImage: settingTabImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
