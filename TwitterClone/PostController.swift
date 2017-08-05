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
    }
    
    @IBAction func handlePost(_ sender: Any) {
        if !postTextView.text.isEmpty && postTextView.text.characters.count <= 140 {
            postButton.isEnabled = true
            postButton.alpha = 1
        }
        
    }
    
    
    
    
}
