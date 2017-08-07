//
//  EditController.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 8/7/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit


class EditController: UIViewController{
    
    @IBOutlet weak var usernameLabel: UITextField!
    
    @IBOutlet weak var firstnameLabel: UITextField!
    
    @IBOutlet weak var lastnameLabel: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func handleSave(_ sender: Any) {
        
        let id = user!["id"] as! String
        
        if usernameLabel.text!.isEmpty  || emailLabel.text!.isEmpty || firstnameLabel.text!.isEmpty || lastnameLabel.text!.isEmpty {
            
            usernameLabel.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.red])
            //passwordField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.red])
            emailLabel.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName: UIColor.red])
            firstnameLabel.attributedPlaceholder = NSAttributedString(string: "firstname", attributes: [NSForegroundColorAttributeName: UIColor.red])
            lastnameLabel.attributedPlaceholder = NSAttributedString(string: "lastname", attributes: [NSForegroundColorAttributeName: UIColor.red])
        }
        else {
            
            
            let url = URL(string: "http://localhost/twitterclone/updateUser.php")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            let body = "username=\(usernameLabel.text!.lowercased())&email=\(emailLabel.text!.lowercased())&fullname=\(firstnameLabel.text!)%20\(lastnameLabel.text!)&id=\(id)"
            request.httpBody = body.data(using: String.Encoding.utf8)
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error)
                }
                guard let data = data else { return }
                print(data)
                DispatchQueue.main.async {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        guard let jsonData = json else { return }
                        print(jsonData)
                        
                        let id = jsonData["id"] as? String
                        if id != nil {
                            guard let message = jsonData["message"] as? String else { return }
                            appdelegate.infoView(message: message, color: greenColor)
                            UserDefaults.standard.set(jsonData, forKey: "user")
                            user = UserDefaults.standard.value(forKey: "user") as! NSDictionary
                            
                            
                            
                            let username = user!["username"] as? String
                            let fullname = user!["fullname"] as? String
                            
                            let fullnameArray = fullname!.characters.split {$0 == " "}.map(String.init) // include 'Fistname Lastname' as array of seperated elements
                            let firstname = fullnameArray[0]
                            let lastname = fullnameArray[1]
                            
                            let email = user!["email"] as? String
                            let ava = user!["ava"] as? String
                            
                            
                            // assign shortcuts to obj
                            
                            self.usernameLabel.text = username
                            self.firstnameLabel.text = firstname
                            self.lastnameLabel.text = lastname
                            self.emailLabel.text = email

                            
                        } else {
                            
                            guard let message = jsonData["message"] as? String else { return }
                            appdelegate.infoView(message: message, color: redColor)
                        }
                        
                    } catch let error {
                        print("JSON error",error)
                    }
                }
            }).resume()
            
            
            
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // shortcuts
        let username = user!["username"] as? String
        let fullname = user!["fullname"] as? String
        
        let fullnameArray = fullname!.characters.split {$0 == " "}.map(String.init) // include 'Fistname Lastname' as array of seperated elements
        let firstname = fullnameArray[0]
        let lastname = fullnameArray[1]
        
        let email = user!["email"] as? String
        let ava = user!["ava"] as? String
        
        
        // assign shortcuts to obj
        self.navigationItem.title = "PROFILE"
        usernameLabel.text = username
        firstnameLabel.text = firstname
        lastnameLabel.text = lastname
        emailLabel.text = email
        
        // get user profile picture
        if ava != "" {
            
            // url path to image
            let imageURL = URL(string: ava!)!
            
            // communicate back user as main queue
            DispatchQueue.main.async(execute: {
                
                // get data from image url
                let imageData = try? Data(contentsOf: imageURL)
                
                // if data is not nill assign it to ava.Img
                if imageData != nil {
                    DispatchQueue.main.async(execute: {
                        self.profileImageView.image = UIImage(data: imageData!)
                    })
                }
            })
            
        }
        
        // round corners
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.clipsToBounds = true
        saveButton.layer.cornerRadius = saveButton.bounds.width / 4.5
        
        // color
        saveButton.backgroundColor = blueColor
        
        // disable button initially
//        saveButton.isEnabled = false
//        saveButton.alpha = 0.4
        
        
    }
}
