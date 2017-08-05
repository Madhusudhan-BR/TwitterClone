//
//  RegisterController.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 7/26/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    
    @IBOutlet weak var firstnameField: UITextField!
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad() 
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    @IBAction func handleRegister(_ sender: Any) {
        
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty || emailField.text!.isEmpty || firstnameField.text!.isEmpty || lastnameField.text!.isEmpty {
            
            usernameField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.red])
            passwordField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.red])
            emailField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName: UIColor.red])
            firstnameField.attributedPlaceholder = NSAttributedString(string: "firstname", attributes: [NSForegroundColorAttributeName: UIColor.red])
            lastnameField.attributedPlaceholder = NSAttributedString(string: "lastname", attributes: [NSForegroundColorAttributeName: UIColor.red])
        }
        else {
        
        let url = URL(string: "http://localhost/twitterclone/register.php")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "username=\(usernameField.text!.lowercased())&password=\(passwordField.text!)&email=\(emailField.text!.lowercased())&fullname=\(firstnameField.text!)%20\(lastnameField.text!)"
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
                            appdelegate.login()
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
    
    @IBAction func handleAlreadyHaveAccount(_ sender: Any) {
    }
    
    
}
