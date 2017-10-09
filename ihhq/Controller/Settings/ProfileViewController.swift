//
//  ProfileViewController.swift
//  ihhq
//
//  Created by Admin on 6/23/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController, ProfileTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var avatar: UIImage? = nil
    var avatarChangeStatus = 0 //0: original, 1: changed, 2: Deleted
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "PROFILE"
        self.tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        
        self.addUpdateButton()
        
    
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyboard()
    }
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    func getUpdatedAddress() -> String {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileTableViewCell
        let address = cell.tvAddress.text ?? ""
        return address
    }
    //add update button
    func addUpdateButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(updateProfile))
    }
    func updateProfile(sender: UIBarButtonItem) {
       doUpdate()
    }
    //MARK: ProfileTableViewCellDelegate
    func changeAvatar(avatar: UIImage) {
        self.avatarChangeStatus = 1
        self.avatar = avatar
    }
    func deleteAvatar() {
        self.avatarChangeStatus = 2
        self.avatar = UIImage(named: "default_user")
    }
    func doUpdate() {
        showProgressHUD()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Global.me.token
        ]
        upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(Global.me.email.data(using: String.Encoding.utf8)!, withName: "email")
            multipartFormData.append(self.getUpdatedAddress().data(using: String.Encoding.utf8)!, withName: "address")
            var imageData: Data? = nil
            if self.avatar != nil && self.avatarChangeStatus > 0 {
                imageData = UIImageJPEGRepresentation(self.avatar!, 0.6)
                multipartFormData.append(imageData!, withName: "photo", fileName: "photo.png", mimeType: "image/png")
            } else {
            }
        }, to: API.UPDATE_PROFILE, headers: headers,
           encodingCompletion: { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    dismissProgressHUD()
                    debugPrint(response)
                    if let statusCode = response.response?.statusCode {
                        print("HTTP response status code is", statusCode);
                        
                        if statusCode == 200 {
                            showAlert("Profile updated successfully", title: "", controller: self)
                            if let value = response.result.value {
                                let json = JSON(value)
                                Global.me.photo = json["photo"].string ?? ""
                                Global.me.address = json["address"].string ?? ""
                            }
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            
                            if let value = response.result.value {
                                let dic = JSON(value)
//                                let errCode = statusCode
                                let errStr = dic["error"].string
                                showAlert(errStr!, title: "Error", controller: self)
                            }
                        }
                    } else {
                        print("Error : \(String(describing: response.result.error))")
                        showAlert(response.result.error as! String, title: "Error", controller: self)
                    }
                    
                })
                upload.responseString(completionHandler: { (response) in
                    dismissProgressHUD()
                    debugPrint(response)
                })
            case .failure(let encodingError):
                dismissProgressHUD()
                print("Encoding Result was FAILURE")
                print(encodingError)
                
            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
extension ProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 510
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.hideKeyboard()
    }
    
}

extension ProfileViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        cell.ivAvatar.makeRound()
        cell.ivAvatar.setImageFromURL(url: API.BASE_IMAGE_URL + Global.me.photo)
        
        cell.tfName.text = Global.me.name
        cell.lblEmail.text = Global.me.email
//        cell.lblCountry.text = String(Global.me.country_id)//should be fix
        cell.lblPassport.text = Global.me.passport_no
        cell.lblMobileNumber.text = "+60 " + Global.me.mobile
        cell.tvAddress.text = Global.me.address
        cell.delegate = self
        cell.vc = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
}
