//
//  TabBarController.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 8/2/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .white
        tabBar.barTintColor = UIColor(red: 45/255, green: 213/255, blue: 255/255, alpha: 1)
        tabBar.isTranslucent = false 
    }
}
