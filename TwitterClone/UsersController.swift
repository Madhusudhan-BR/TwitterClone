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
    var images = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.barTintColor = .white
        searchBar.tintColor = blueColor
        searchBar.showsCancelButton = false
        doSearch(word: "")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let word = searchText
        doSearch(word: word)
    }
    
    func doSearch(word: String){
        
        let username = user!["username"] as! String
        let url = URL(string: "http://localhost/TwitterClone/user.php")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "word=\(word)&username=\(username)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else {
                        return
                    }
                    
                    self.users.removeAll()
                    self.images.removeAll()
                    self.tableView.reloadData()
                    
                    print(json)
                    guard let users = json["users"] as? [AnyObject] else { return }
                    
                    self.users = users
                    
                    for i in 0..<self.users.count {
                        
                        let ava = self.users[i]["ava"] as? String
                        
                        if ava != "" {
                            let url = URL(string: ava!)
                            let imageData = NSData(contentsOf: url!)
                            let image = UIImage(data: imageData as! Data)
                            self.images.append(image!)
                        } else {
                            self.images.append(UIImage())
                        }
                    }
                  
                    self.tableView.reloadData()
                    
                    
                } catch let jsonError {
                    print(error)
                    return
                }
            }
            
            }.resume()
        

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(false)
        searchBar.showsCancelButton = false
        
        doSearch(word: "")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let user = users[indexPath.row]
        
        
        cell.fullnameLabel.text = user["fullname"] as? String
        cell.usernameLabel.text = user["username"] as? String
        cell.profileImageView.image = self.images[indexPath.row]
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
}
