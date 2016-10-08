//
//  HelpViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-10-08.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    //IBOutlet
    @IBOutlet weak var webView: UIWebView!
    
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: "http://sanghyunju.wixsite.com/hippo");
        let requestObj = NSURLRequest(url: url! as URL);
        webView.loadRequest(requestObj as URLRequest);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
