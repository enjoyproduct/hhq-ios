//
//  NotificationViewController.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

protocol NotificationViewControllerDelegate {
    func navigateTo(type: Int) //type: 0: home, 1: correspondence
}

class NotificationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var arrNotifications = [NotificationModel]()
    var url = ""
    
    var delegate: NotificationViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setTitle(title: "NOTIFICATIONS")
        self.tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        self.tableView.addInfiniteScrolling{
            self.insertAtBottom()
        }
        self.url = API.GET_NOTIFICATIONS
        get_notifications()
    }
    func insertAtBottom() {
        self.tableView.infiniteScrollingView.stopAnimating()
        get_notifications()
        
    }
    func get_notifications()  {
        if (self.url == "") {
            return
        }
        
        showProgressHUD()
        APIManager.sendRequest(method: .get, urlString: url, params: nil, succeedHandler: { (result) in
            dismissProgressHUD()
            if let next_page_url = result["next_page_url"].string {
                self.url = next_page_url
            } else {
                self.url = ""
            }
            let jsonArray = result["data"].array
            
            for notification in jsonArray! {
                let item = NotificationModel(json: notification)
                self.arrNotifications.append(item)
            }
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
extension NotificationViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = self.arrNotifications[indexPath.row]
        if !notification.message.replacingOccurrences(of: " ", with: "").isEmpty {
            showAlert(notification.message, title: "Details", controller: self)
        }
        
        
    }
    
}

extension NotificationViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        let notification = self.arrNotifications[indexPath.row]
        cell.lblCase.text = notification.subject
        cell.lblFileRef.text = notification.file_ref
        cell.lblMessage.text = notification.message
        cell.lblTime.text = timeFormatter(strTime: notification.created_at)
        return cell
    }
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
}
