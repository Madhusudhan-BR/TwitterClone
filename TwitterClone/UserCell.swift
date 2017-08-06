//
//  UserCell.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 8/6/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell{
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        usernameLabel.textColor = blueColor
    }
}
