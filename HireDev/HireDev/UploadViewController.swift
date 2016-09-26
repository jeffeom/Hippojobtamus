//
//  UploadViewController.swift
//  HireDev
//
//  Created by Jeff Eom on 2016-09-22.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    let category: [String] = ["Cafe", "Server", "Tutor", "Sales", "Reception", "Grocery", "Bank", "Others"]
    var hidden: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = category[indexPath.row]
        
        return cell
    }
    
    //MARK: Button
    
    @IBAction func showTableView(_ sender: AnyObject) {
        if hidden == true{
            UIView.animate(withDuration: 0.2) {
                self.tableView.isHidden = false
            }
            hidden = false
        }else{
            UIView.animate(withDuration: 0.2) {
                self.tableView.isHidden = true
            }
            hidden = true
        }
    }
    
}
