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
        navigationItem.title = "PROFILE"
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
        saveButton.isEnabled = false
        saveButton.alpha = 0.4
        
        
    }
}
