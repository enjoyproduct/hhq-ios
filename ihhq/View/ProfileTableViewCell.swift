//
//  ProfileTableViewCell.swift
//  ihhq
//
//  Created by Admin on 6/24/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
protocol ProfileTableViewCellDelegate {
    func changeAvatar(avatar: UIImage)
    func deleteAvatar()
}
class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblPassport: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var tvAddress: UITextView!
    
    @IBOutlet weak var avoidingView: UIView!
    
    var vc: ProfileViewController? = nil
    var delegate: ProfileTableViewCellDelegate? = nil
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func onChange(_ sender: Any) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        if self.vc != nil {
            self.vc?.present(self.imagePicker, animated: true, completion: nil)
        }
        
    }
    @IBAction func onDelete(_ sender: Any) {
        self.ivAvatar.image = UIImage(named: "default_user")
        if self.delegate != nil {
            self.delegate?.deleteAvatar()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        KeyboardAvoiding.avoidingView = self.avoidingView
        
        self.imagePicker.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ProfileTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePicker Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.ivAvatar.image = chosenImage
        if self.delegate != nil {
            self.delegate?.changeAvatar(avatar: chosenImage)
        }
        self.vc?.dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.vc?.dismiss(animated: true, completion: nil)
    }
}
