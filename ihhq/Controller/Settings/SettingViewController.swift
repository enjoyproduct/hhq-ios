//
//  SettingViewController.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

    let titles:[String] = ["Update Profile", "Terms of Use and Privacy", "Notification", "Change Password"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setTitle(title: "SETTINGS")
    }

    func updateNotification(isEnable: Bool) {
        let paramsDict: NSMutableDictionary = [
            "enable": String(isEnable ? 1 : 0)
            ]
        APIManager.sendRequest(method: .post, urlString: API.ENABLE_NOTIFICATION, params: paramsDict, succeedHandler: { (result) in
            dismissProgressHUD()
            Global.me.is_enable_push = isEnable ? 1 : 0
            self.tableView.reloadData()
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
    
}
extension SettingViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 1 {
            UIApplication.shared.open(URL(string: API.TERMS_AND_POLICY)!, options: [:], completionHandler: nil)
        } else if indexPath.row == 2 {
            
        }
    }
    
}

extension SettingViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.textLabel?.font = robotoMedium(size: 14)
        if indexPath.row != 2 {
            cell.accessoryType = .disclosureIndicator
            
        } else {
            let settingSwitch = UISwitch()
            settingSwitch.tag = indexPath.row
            if Global.me.is_enable_push == 1 {
                settingSwitch.isOn = true
            } else {
                settingSwitch.isOn = false
            }
            
            settingSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
            settingSwitch.onTintColor = Constant.colorPrimary
            cell.accessoryView = settingSwitch
            
        }
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    func switchValueChanged(_ sender: UISwitch) {
//        defaults.set(sender.isOn, forKey: rows[sender.tag].rawValue)
        Global.me.is_enable_push = sender.isOn ? 1 : 0
        self.updateNotification(isEnable: sender.isOn)
    }
}
