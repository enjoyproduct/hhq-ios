//
//  MenuViewController.swift
//  ihhq
//
//  Created by Admin on 6/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var images = ["menu_home", "menu_notification", "menu_empower", "menu_support", "menu_scan_qr_code", "menu_setting", "menu_sign_out"]
    var titles = ["Home", "Notifications", "Empower", "My Correspondence","Scan QR Code", "Settings", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        
    }
    func changeViewController(index: Int) {
        switch index {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: vc), close: true)
            break
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: vc), close: true)
            break
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmpowerViewController") as! EmpowerViewController
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: vc), close: true)
            break
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupportContainerViewController") as! SupportContainerViewController
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: vc), close: true)
            break
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanQRCodeViewController") as! ScanQRCodeViewController
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: vc), close: true)
            break
        case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: vc), close: true)
            break
        case 6:
            self.slideMenuController()?.changeMainViewController((self.slideMenuController()?.mainViewController)!, close: true)
            showLogoutConfrimAlert("Confirm logout?", title: Constant.INDECATOR)
            break
        default:
            
            break
        }
    }
    func doLogout() {
        
        showProgressHUD()
        let email = getStringFromUserDefault(Constant.EMAIL)
        let password = getStringFromUserDefault(Constant.PASSWORD)
        let paramsDict: NSMutableDictionary = [
            "email": email,
            "password": password]
        APIManager.sendRequest(method: .post, urlString: API.LOGOUT, params: paramsDict, succeedHandler: { (result) in
            dismissProgressHUD()
            //logout
            setObjectToUserDefault(Constant.EMAIL, object:"" as AnyObject)
            setObjectToUserDefault(Constant.PASSWORD, object:"" as AnyObject)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "initialNavVC") as! UINavigationController
            appDelegate.chageRootViewController(newRootViewController: vc)
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })
        
    }
    
    func showLogoutConfrimAlert(_ message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Logout", style: .default) { (action) in
            self.doLogout()
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true)        
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
extension MenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.changeViewController(index: indexPath.row)
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = Constant.colorPrimary
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellToDeSelect:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.clear
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension MenuViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.setData(title: titles[indexPath.row], imageName: images[indexPath.row])
//        if(cell.isSelected){
//            cell.backgroundColor = Constant.colorPrimary
//        }else{
//            cell.backgroundColor = UIColor.clear
//        }
        return cell
    }
    
    
}
