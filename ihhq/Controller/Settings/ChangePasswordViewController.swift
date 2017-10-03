//
//  ChangePasswordViewController.swift
//  ihhq
//
//  Created by Admin on 7/26/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var viewCurrentPassword: UIView!
    @IBOutlet weak var viewNewPassword: UIView!
    @IBOutlet weak var viewConfirmPassword: UIView!
    @IBOutlet weak var tfCurrentPassword: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var btnUpdatePassword: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utils.drawFrame(to: self.viewCurrentPassword, corner: Constant.cornerRadius5, border: 1.0, color: UIColor.black)
        Utils.drawFrame(to: self.viewNewPassword, corner: Constant.cornerRadius5, border: 1.0, color: UIColor.black)
        Utils.drawFrame(to: self.viewConfirmPassword, corner: Constant.cornerRadius5, border: 1.0, color: UIColor.black)
        
        self.btnUpdatePassword.layer.cornerRadius = Constant.cornerRadius5;
        self.btnUpdatePassword.layer.masksToBounds = true;

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyboard()
    }
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    @IBAction func onUpdatePassword(_ sender: Any) {
        if self.checkCurrentPass() {
            doUpdatePassword()
        }
    }
    func checkCurrentPass() -> Bool{
        if getStringFromUserDefault(Constant.PASSWORD) != tfCurrentPassword.text {
            showAlert("Current password is incorrect", title: Constant.INDECATOR, controller: self)
            return false
        }
        if (tfNewPassword.text?.characters.count)! < 6 {
            showAlert("Password should be longer than 6", title: Constant.INDECATOR, controller: self)
            return false
        }
        if tfNewPassword.text != tfConfirmPassword.text {
            showAlert("Confirm password does not match", title: Constant.INDECATOR, controller: self)
            return false
        }
        return true
    }
    func doUpdatePassword() {
        self.hideKeyboard()
        showProgressHUD()
        
        let paramsDict: NSMutableDictionary = [
            "current_password": tfCurrentPassword.text ?? "",
            "password": tfNewPassword.text ?? "",
            "password_confirmation": tfConfirmPassword.text ?? ""
            ]
        APIManager.sendRequest(method: .post, urlString: API.CHANGE_PASSWORD, params: paramsDict, succeedHandler: { (result) in
            dismissProgressHUD()
            if let response = result["result"].string {
                showAlert(response, title: "Error", controller: self)
            } else {
                Global.me.password = self.tfNewPassword.text!
                setObjectToUserDefault(Constant.PASSWORD, object: Global.me.password as AnyObject)
                //
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
