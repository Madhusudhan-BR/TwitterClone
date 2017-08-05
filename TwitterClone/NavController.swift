//
//  NavController.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 8/2/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
let blueColor = UIColor(red: 45/255, green: 213/255, blue: 255/255, alpha: 1)
class NavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.tintColor = .white
        navigationBar.barTintColor = UIColor(red: 45/255, green: 213/255, blue: 255/255, alpha: 1)
        navigationBar.isTranslucent = false 
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
