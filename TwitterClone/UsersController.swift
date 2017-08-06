//
//  UsersController.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 8/6/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit


class UsersController: UITableViewController,UISearchBarDelegate{
   
    @IBOutlet weak var searchBar: UISearchBar!
    var users = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.barTintColor = .white
        searchBar.tintColor = blueColor
        searchBar.showsCancelButton = false
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(false)
        searchBar.showsCancelButton = false 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
}
