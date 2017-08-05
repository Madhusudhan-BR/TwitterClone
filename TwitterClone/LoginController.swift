//
//  LoginController.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 8/2/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func handleLogin(_ sender: Any) {
        
        if (usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            usernameField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName : UIColor.red])
            passwordField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : UIColor.red])
        }
        else {
            guard let username = usernameField.text?.lowercased(), let password = passwordField.text else { return }
            
            guard  let url = URL(string: "http://localhost/twitterclone/Login.php") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let body = "username=\(username)&password=\(password)"
            request.httpBody = body.data(using: String.Encoding.utf8)
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    do {
                        guard let jsonData =  try  JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else { return }
                        
                        print(jsonData)
                        
                        let id = jsonData["id"] as? String
                        if id != nil {
                            guard let message = jsonData["message"] as? String else { return }
                            appdelegate.infoView(message: message, color: greenColor)
                            UserDefaults.standard.set(jsonData, forKey: "user")
                            user = UserDefaults.standard.value(forKey: "user") as! NSDictionary
                            appdelegate.login() 
                        } else {
                            
                            guard let message = jsonData["message"] as? String else { return }
                            appdelegate.infoView(message: message, color: redColor)
                            
                        }
                        
                        
                    } catch let jsonError {
                        print(jsonError.localizedDescription)
                        return
                    }
                   
                    
                }
                
            }).resume()
            
        }
        
    }
}
