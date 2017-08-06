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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
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
