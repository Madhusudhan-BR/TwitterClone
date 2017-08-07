//
//  GuestController.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 8/7/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class GuestController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    var tweets = [AnyObject]()
    var images = [UIImage]()
    
    var guest = NSDictionary() {
        didSet{
            loadPosts()
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let username = (guest["username"] as? String)?.uppercased()
        let fullname = (guest["fullname"] as? String)
        let email = (guest["email"] as? String)
        let ava = (guest["ava"] as? String)
        
        usernameLabel.text = username
        emailLabel.text = email
        fullnameLabel.text = fullname
        
        // get user profile pic
        
        
        if ava != "" {
            guard let imageUrl = URL(string: ava!) else { return }
            guard let imageData = NSData(contentsOf: imageUrl) else { return }
            let image = UIImage(data: imageData as! Data)
            DispatchQueue.main.async {
                self.profilePictureImageView.image = image
            }
        }
        
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.bounds.width / 20;
        profilePictureImageView.clipsToBounds = true
        self.navigationItem.title = username
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
  
    
    
        
    func loadPosts(){
        print(guest)
        guard let id = guest["id"] as? String else { return }
        let url = URL(string: "http://localhost/TwitterClone/post.php")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "id=\(id)&text=&uuid=".data(using: .utf8)
        
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
                    self.images.removeAll()
                    self.tweets.removeAll()
                    guard let posts = json["posts"] as? [AnyObject] else { return }
                    
                    self.tweets = posts
                    
                    for i in 0..<self.tweets.count {
                        let url = self.tweets[i]["path"] as? String
                        
                        if url != "" {
                            let imageURL = URL(string: url!)
                            let imageData = NSData(contentsOf: imageURL!)
                            let image = UIImage(data: imageData! as Data)
                            self.images.append(image!)
                        } else {
                            self.images.append(UIImage())
                        }
                    }
                    
                    
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    
                } catch let jsonError {
                    print(error)
                    return
                }
            }
            
            }.resume()
        
        
        
        
    }
    
    //MARK: table view functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostCell
        let tweet = tweets[indexPath.row]
        
        guard let date = tweet["date"] as? String else { return UITableViewCell() }
        guard let username = tweet["username"] as? String else { return UITableViewCell() }
        guard let text = tweet["text"] as? String else { return  UITableViewCell() }
        
        cell.dateLabel.text = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let newDate = dateFormatter.date(from: date)
        
        guard let fromDate = newDate else { return UITableViewCell()}
        let now = NSDate()
        let components : NSCalendar.Unit = [.second,.minute,.hour,.day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: fromDate, to: now as Date, options: [])
        
        // calculate date
        if difference.second! <= 0 {
            cell.dateLabel.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.dateLabel.text = "\(difference.second!)s." // 12s.
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.dateLabel.text = "\(difference.minute!)m."
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.dateLabel.text = "\(difference.hour!)h."
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.dateLabel.text = "\(difference.day!)d."
        }
        if difference.weekOfMonth! > 0 {
            cell.dateLabel.text = "\(difference.weekOfMonth!)w."
        }
        
        cell.pictureView.image = images[indexPath.row]
        cell.usernameLabel.text = username
        cell.tweetText.text = text
        
        if images[indexPath.row].size.width == 0 || images[indexPath.row].size.height == 0 {
            DispatchQueue.main.async {
                cell.tweetText.frame.origin.x = self.view.frame.width / 16
                cell.tweetText.frame.size.width = self.view.frame.width -  self.view.frame.width / 8
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
  
    
}
