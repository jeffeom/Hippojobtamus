//
//  SearchBarViewController.swift
//  Hippo
//
//  Created by Jeff Eom on 2016-11-18.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit
import MapKit

protocol SearchBarViewControllerDelegate {
    func acceptLocationData(data: AnyObject!)
}

class SearchBarViewController: UIViewController, UISearchBarDelegate,MKLocalSearchCompleterDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var delegate: SearchBarViewControllerDelegate?
    var data: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchCompleter.delegate = self
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchText.characters.count == 0{
            searchResults = []
            tableView.reloadData()
        }else{
            searchCompleter.queryFragment = searchText
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text?.characters.count == 0{
            searchResults = []
            tableView.reloadData()
        }else{
            searchCompleter.queryFragment = searchBar.text!
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell")
        
        if searchResults[indexPath.row].subtitle.characters.count != 0 {
            cell?.textLabel?.text = searchResults[indexPath.row].title + " " + "(" + searchResults[indexPath.row].subtitle + ")"
        }else{
            cell?.textLabel?.text = searchResults[indexPath.row].title
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let navController = self.navigationController {
            self.delegate?.acceptLocationData(data: [searchResults[indexPath.row].title, searchResults[indexPath.row].subtitle] as AnyObject)
            navController.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
