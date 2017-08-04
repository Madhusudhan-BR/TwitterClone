//
//  HomeController.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 8/3/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class HomeController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBAction func handleLogout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "user")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyboard.instantiateViewController(withIdentifier: "login") as! LoginController
        present(loginController, animated: true , completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
              let username = (user!["username"] as? String)?.uppercased()
        let fullname = (user!["fullname"] as? String)
        let email = (user!["email"] as? String)
        let ava = (user!["ava"] as? String)
        
        usernameLabel.text = username
        emailLabel.text = email
        fullnameLabel.text = fullname
        
        // get user profile pic  
        
        
        if ava != "" {
            guard let imageUrl = URL(string: ava!) else { return }
            guard let imageData = NSData(contentsOf: imageUrl) else { return }
            let image = UIImage(data: imageData as! Data)
            DispatchQueue.main.async {
                self.profilePictureImageView.image = image
            }
        }
        
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.bounds.width / 20;
        profilePictureImageView.clipsToBounds = true
        self.navigationItem.title = username
        
    }
    @IBAction func handleEditProfilePicture(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate  = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        profilePictureImageView.image = image
        dismiss(animated: true, completion: nil)
        uploadAva()
    }
    
    
    func createBodyWithParams(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "ava.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
        
        
    }
    
    func uploadAva(){
        let url = URL(string: "http://localhost/TwitterClone/uploadava.php")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let id = user!["id"] as! String
        let params = ["id": id]
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(profilePictureImageView.image!, 0.5)
        if imageData == nil { return }
        
        request.httpBody = createBodyWithParams(parameters: params, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    return
                }
                guard let data = data else { return }
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                    
                    guard let parseJson = json else { return }
                    print(parseJson)
                    
                    let id = parseJson["id"]
                    
                    if id != nil {
                    UserDefaults.standard.set(parseJson, forKey: "user")
                    user = UserDefaults.standard.value(forKey: "user") as! NSDictionary
                    }
                    else {
                    
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            }
            
          
            
        }.resume()
        
    }
}

extension NSMutableData {
    func appendString(string: String){
        let data = string.data(using: .utf8, allowLossyConversion: true)
        append(data!)
    }
}
