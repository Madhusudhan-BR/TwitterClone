//
//  PostController.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 8/5/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class PostController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var selectPictureButton: UIButton!
    @IBOutlet weak var selectedPictureImageView: UIImageView!
    
    @IBOutlet weak var postButton: UIButton!
    
    
    var uuid = String()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTextView.delegate = self
        
        postTextView.layer.cornerRadius = postTextView.bounds.width/50
        postButton.layer.cornerRadius = postButton.bounds.width/20
        
        postButton.backgroundColor = UIColor(red: 45/255, green: 213/255, blue: 255/255, alpha: 1)
        selectPictureButton.setTitleColor(blueColor, for: .normal)
        postButton.isEnabled = false
        postButton.alpha = 0.4
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let whitespaces = NSCharacterSet.whitespacesAndNewlines
        let chars = postTextView.text.characters.count
        countLabel.text = String(140-chars)
        
        if chars > 140 {
            postButton.isEnabled = false
            postButton.alpha = 0.4
            countLabel.textColor = redColor
        } else if postTextView.text.trimmingCharacters(in: whitespaces).isEmpty {
            postButton.isEnabled = false
            postButton.alpha = 0.4

        } else {
            postButton.isEnabled = true
            postButton.alpha = 1
            countLabel.textColor = UIColor.lightGray
        }
    }
    
    
    //touching screen 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    @IBAction func handleSelectPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }
        self.selectedPictureImageView.image = image
        dismiss(animated: true, completion: nil)
        imageSelected = true
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
        
        var filename = ""
        
        if imageSelected {
            filename = "post-\(uuid).jpg"
        }
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func uploadPost(){
        
        let id = user!["id"] as! String
        uuid = NSUUID().uuidString
        let text = postTextView.text as String
        
        let url = URL(string: "http://localhost/TwitterClone/post.php")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let param = ["id" : id , "uuid": uuid , "text": text]
        
        let boundary = "boundary-\(NSUUID().uuidString)"
        
        var imageData = NSData()
        
        if selectedPictureImageView.image != nil {
            
            imageData = UIImageJPEGRepresentation(selectedPictureImageView.image!, 0.5) as! NSData
            
        }
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBodyWithParams(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary) as Data
        
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
      
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else { return }
                    
                    DispatchQueue.main.async {
                         print(json)
                        self.postTextView.text = ""
                        self.selectedPictureImageView.image = nil
                        self.postButton.isEnabled = false
                        self.postButton.alpha = 0.4
                        self.countLabel.text = "140"
                        self.tabBarController?.selectedIndex = 0
                        self.imageSelected = false
                    }
                    
                } catch let jsonError {
                    
                    print(jsonError.localizedDescription)
                    return
                    
                }
                
                
                
            }
            
        }.resume()
    }
    
    @IBAction func handlePost(_ sender: Any) {
        if !postTextView.text.isEmpty && postTextView.text.characters.count <= 140 {
            postButton.isEnabled = true
            postButton.alpha = 1
            uploadPost()
        }
        
    }
    
    
    
    
}
