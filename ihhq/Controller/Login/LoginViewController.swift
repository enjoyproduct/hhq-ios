//
//  LoginViewController.swift
//  ihhq
//
//  Created by Admin on 6/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class LoginViewController: UIViewController, BFPaperCheckboxDelegate{

    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var viewRememberMe: UIView!
    
    var checkbox: BFPaperCheckbox? = nil
    
    @IBOutlet weak var keyboardAvoidingView: UIView!
    
    var email = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //draw white border
        Utils.drawFrame(to: self.viewEmail, corner: Constant.cornerRadius5, border: 1.0, color: UIColor.white)
        Utils.drawFrame(to: self.viewPassword, corner: Constant.cornerRadius5, border: 1.0, color: UIColor.white)
        Utils.drawFrame(to: self.viewRememberMe, corner: Constant.cornerRadius5, border: 1.0, color: UIColor.white)
        
        self.btnLogin.layer.cornerRadius = Constant.cornerRadius5;
        self.btnLogin.layer.masksToBounds = true;
        
        KeyboardAvoiding.avoidingView = self.keyboardAvoidingView
        addCheckbox()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.checkAutoLogin()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyboard()
    }
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    func addCheckbox() {
        
        self.checkbox = BFPaperCheckbox(frame: CGRect(x: 20, y: 5, width: 25, height: 25))
        self.checkbox?.tag = 1001
        self.checkbox?.delegate = self
        self.checkbox?.tintColor = UIColor.black
        self.checkbox?.checkmarkColor = UIColor.black
        self.viewRememberMe.addSubview(self.checkbox!)
    }
    
    //MARK: - BFPaperCheckboxDelegate
    func paperCheckboxChangedState(_ checkbox: BFPaperCheckbox!) {
        
    }
    func checkAutoLogin() {
        self.email = getStringFromUserDefault(Constant.EMAIL)
        self.password = getStringFromUserDefault(Constant.PASSWORD)
        if self.email.characters.count > 0 && self.password.characters.count > 0 {
            self.tfEmail.text = self.email
            doLogin()
        }
    }
    @IBAction func onLogin(_ sender: Any) {
        if self.tfEmail.text?.characters.count == 0 {
            showAlert("Please input email", title: Constant.INDECATOR, controller: self)
            return
        }
        if !isValidEmail(self.tfEmail.text!) {
            showAlert("Invalid email", title: Constant.INDECATOR, controller: self)
            return
        }
        if self.tfPassword.text?.characters.count == 0 {
            showAlert("Please input password", title: Constant.INDECATOR, controller: self)
            return
        }
        
        self.email = self.tfEmail.text!
        self.password = self.tfPassword.text!
        
        doLogin()

        
        
        
    }

    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    func doLogin() {
        self.hideKeyboard()
        showProgressHUD()
        
        let paramsDict: NSMutableDictionary = [
            Constant.DEVICE_TOKEN: getStringFromUserDefault(Constant.DEVICE_TOKEN),
            Constant.DEVICE_TYPE: Constant.iOS,
            "email": self.email,
            "password": self.password]
        APIManager.sendRequest(method: .post, urlString: API.LOGIN, params: paramsDict, succeedHandler: { (result) in
            dismissProgressHUD()
            
            if (self.checkbox?.isChecked)! {
                setObjectToUserDefault(Constant.EMAIL, object:self.email as AnyObject)
                setObjectToUserDefault(Constant.PASSWORD, object:self.password as AnyObject)
            }

            Global.me = UserModel(json: result);
            //
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuConainerViewController") as! MenuConainerViewController
            appDelegate.chageRootViewController(newRootViewController: vc)
            
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
