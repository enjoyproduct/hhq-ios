//
//  ForgotPasswordViewController.swift
//  ihhq
//
//  Created by Admin on 6/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class ForgotPasswordViewController: UIViewController {

    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnResetPassword: UIButton!
    @IBOutlet weak var viewEmail: UIView!
    
    @IBOutlet weak var keyboardAvoidingView: UIView!
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //draw white border
        Utils.drawFrame(to: self.viewEmail, corner: Constant.cornerRadius5, border: 1.0, color: UIColor.white)
        
        self.btnResetPassword.makeRoundCorner(cornerRadius: 5)
        
    
        KeyboardAvoiding.avoidingView = self.keyboardAvoidingView
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyboard()
    }
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func onResetPassword(_ sender: Any) {
        if self.tfEmail.text?.characters.count == 0 {
            showAlert("Please input email", title: Constant.INDECATOR, controller: self)
            return
        }
        if !isValidEmail(self.tfEmail.text!) {
            showAlert("Invalid email", title: Constant.INDECATOR, controller: self)
            return
        }
        self.email = self.tfEmail.text!
        self.forgotPassword()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func forgotPassword()  {
        self.hideKeyboard()
        showProgressHUD()
        
        let paramsDict: NSMutableDictionary = [
            
            "email": self.email]
        APIManager.sendRequest(method: .post, urlString: API.FORGOT_PASSWORD, params: paramsDict, succeedHandler: { (result) in
            dismissProgressHUD()
            self.showConfrimAlert("Please check your email", title: Constant.INDECATOR, controller: self)
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })
        
    }
    
    func showConfrimAlert(_ message: String, title: String, controller:UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(OKAction)
        
        controller.present(alertController, animated: true) {
            
        }
        
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
