//
//  PostCell.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 8/5/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
   
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLabel.textColor = blueColor
    }
    
    
    
}
