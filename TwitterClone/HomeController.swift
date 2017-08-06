//
//  HomeController.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 8/3/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class HomeController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
   var tweets = [AnyObject]()
    var images = [UIImage]()
    
    @IBAction func handleLogout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "user")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyboard.instantiateViewController(withIdentifier: "login") as! LoginController
        present(loginController, animated: true , completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let username = (user!["username"] as? String)?.uppercased()
        let fullname = (user!["fullname"] as? String)
        let email = (user!["email"] as? String)
        let ava = (user!["ava"] as? String)
        
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
        loadPosts()
    }
    
    @IBAction func handleEditProfilePicture(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate  = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        profilePictureImageView.image = image
        dismiss(animated: true, completion: nil)
        uploadAva()
    }
    
    
    func createBodyWithParams(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "ava.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
        
        
    }
    
    func uploadAva(){
        let url = URL(string: "http://localhost/TwitterClone/uploadava.php")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let id = user!["id"] as! String
        let params = ["id": id]
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(profilePictureImageView.image!, 0.5)
        if imageData == nil { return }
        
        request.httpBody = createBodyWithParams(parameters: params, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    return
                }
                guard let data = data else { return }
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                    
                    guard let parseJson = json else { return }
                    print(parseJson)
                    
                    let id = parseJson["id"]
                    
                    if id != nil {
                    UserDefaults.standard.set(parseJson, forKey: "user")
                    user = UserDefaults.standard.value(forKey: "user") as! NSDictionary
                    }
                    else {
                    
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            }
            
          
            
        }.resume()
        
    }
    
    func loadPosts(){
        
        let id = user!["id"] as! String
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
                    
                    print(self.tweets)
                    
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

extension NSMutableData {
    func appendString(string: String){
        let data = string.data(using: .utf8, allowLossyConversion: true)
        append(data!)
    }
}
