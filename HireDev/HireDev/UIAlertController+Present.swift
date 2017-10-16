//
//  UIAlertController+Present.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-27.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

extension UIAlertController {
  
  func show() {
    present(true, completion: nil)
  }
  
  func present(
    _ animated: Bool, completion: (() -> Void)?) {
    if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
      presentFromController(rootVC, animated: animated, completion: completion)
    }
  }
  
  fileprivate func presentFromController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
    if  let navVC = controller as? UINavigationController,
      let visibleVC = navVC.visibleViewController {
      presentFromController(visibleVC, animated: animated, completion: completion)
    } else {
      if  let tabVC = controller as? UITabBarController,
        let selectedVC = tabVC.selectedViewController {
        presentFromController(selectedVC, animated: animated, completion: completion)
      } else {
        controller.present(self, animated: animated, completion: completion)
      }
    }
  }
}
