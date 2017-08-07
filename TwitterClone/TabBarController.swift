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
        
        logoAnimation()
        
        tabBar.tintColor = .white
        tabBar.barTintColor = UIColor(red: 45/255, green: 213/255, blue: 255/255, alpha: 1)
        tabBar.isTranslucent = false
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.lightGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: .selected)
        
        for item in self.tabBar.items as! [UITabBarItem]{
            if  let image = item.image {
                item.image = image.imageColor(color: UIColor.lightGray).withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    func logoAnimation(){
        let layer = UIView()
        layer.frame = self.view.frame
        layer.backgroundColor = blueColor
        view.addSubview(layer)
        
        let icon = UIImageView()
        icon.image = UIImage(named: "twitter.png")
        icon.frame.size.width = 100
        icon.frame.size.height = 100
        icon.layer.cornerRadius = 50
        icon.clipsToBounds = true
        icon.center = view.center
        view.addSubview(icon)
        
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveLinear, animations: {
            icon.transform = CGAffineTransform( scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                icon.transform = CGAffineTransform( scaleX: 20 , y: 20)
                
                UIView.animate(withDuration: 0.1, delay: 0.3, options: .curveLinear, animations: {
                    icon.alpha = 0
                    layer.alpha = 0
                }, completion: nil)
                
            })
        }
    }
}

extension UIImage {
    func imageColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext() as! CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as! UIImage
        UIGraphicsEndImageContext()
        return newImage
    }
}
