//
//  HomeController.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 8/3/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
       let username = (user!["username"] as? String)?.uppercased()
        let fullname = (user!["fullname"] as? String)
        let email = (user!["email"] as? String)
        let ava = (user!["ava"] as? String)
        
        usernameLabel.text = username
        emailLabel.text = email
        fullnameLabel.text = fullname
        
    }
    @IBAction func handleEditProfilePicture(_ sender: Any) {
    }
}
