//
//  Utils.swift
//  Heyoe
//
//  Created by Admin on 8/26/16.
//  Copyright © 2016 Admin. All rights reserved.
//
import UIKit
import Foundation
import SVProgressHUD

let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

let UserDefaults = Foundation.UserDefaults.standard


func showAlert(_ message: String, title: String, controller:UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//        // ...
//    }
//    alertController.addAction(cancelAction)
    
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        // ...
    }
    alertController.addAction(OKAction)
    
    controller.present(alertController, animated: true) {
        
    }
    
}
func isValidEmail(_ testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
/////user default utils

func getStringFromUserDefault(_ key:String) -> String {
    if let data_str = UserDefaults.object(forKey: key) as? String
    {
        return data_str
    }
    return ""
    
}
func getIntFromUserDefault(_ key:String) -> Int {
    let data = UserDefaults.object(forKey: key)
    if data == nil {
        return 0
    } else {
        return data as! Int
    }

   }
func setObjectToUserDefault(_ key:String, object: AnyObject) {
    UserDefaults.set(object, forKey: key)
}
func showProgressHUD() {
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
    SVProgressHUD.show()
}
func dismissProgressHUD()  {
    SVProgressHUD.dismiss()
}

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

