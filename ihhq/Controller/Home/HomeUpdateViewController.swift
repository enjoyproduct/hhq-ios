//
//  HomeUpdateViewController.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class HomeUpdateViewController: UIViewController, HomeUpdateLogisticTableViewCellDelegate, ScanQRCodeViewControllerDelegate {

    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    var expandedRows = Set<IndexPath>()
    var fileModel: FileModel? = nil
    var url = ""
    var arrUpdates: [(String, [UpdateModel])] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "HomeUpdateTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeUpdateTableViewCell")
        self.tableView.register(UINib(nibName: "HomeUpdateLogisticTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeUpdateLogisticTableViewCell")
        self.url = String(format: API.GET_LOGISTICS_MILESTONES, (fileModel?.file_id)!)
        get_updates()
    }
    func insertAtBottom() {
        self.tableView.infiniteScrollingView.stopAnimating()
        get_updates()
        
    }
    func insertAtTop()  {
        self.tableView.pullToRefreshView.stopAnimating()
        
    }
    func get_updates()  {
        if self.url == "" {
            return
        }
        showProgressHUD()
        APIManager.sendRequest(method: .get, urlString: self.url, params: nil, succeedHandler: { (result) in
            dismissProgressHUD()
            
            let jsonArray = result.arrayValue
            let count = jsonArray.count
            if count > 0 {
                var updates = [UpdateModel]()
                var date = jsonArray[0]["key"].string
                for i in 0...jsonArray.count - 1 {
                    let currentDate = jsonArray[i]["key"].string
                    let updateModel = UpdateModel(jsonObject: jsonArray[i])
                    
                    if date != currentDate {
                        self.arrUpdates.append((date!, updates))
                        date = currentDate
                        updates = []
                    }
                    updates.append(updateModel)
                    if i == jsonArray.count - 1 {
                        self.arrUpdates.append((date!, updates))
                    }
                    ///
                    if updateModel.type != "dispatche" {
                        self.lblPercent.text = (updateModel.milestoneModel?.percent)! + "%"
                        let percent = Float((updateModel.milestoneModel?.percent)!)!
                        self.progressBar.progress = percent / 100
                        if  percent <= 25 {
                            self.progressBar.tintColor = Constant.red
                        } else if percent <= 50 {
                            self.progressBar.tintColor = Constant.colorPrimary
                        } else if percent <= 75 {
                            self.progressBar.tintColor = Constant.lightGreen
                        } else {
                            self.progressBar.tintColor = Constant.green
                        }

                    }
                }
                self.tableView.reloadData()
                
            }
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })
        
    }

    //MARK: HomeUpdateTableViewCellDelegate method
    func onScan(section: Int, row: Int) {
        let updates = self.arrUpdates[section].1 
        let item = updates[row]
        if item.logisticModel?.status == 0 && self.fileModel != nil { //delivered
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanQRCodeViewController") as! ScanQRCodeViewController
            vc.file_ref = (self.fileModel?.file_ref)!
            vc.dispatch_id = (item.logisticModel?.dispatch_id)!
            vc.section = section
            vc.row = row
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //MARK: ScanQRCodeViewControllerDelegate 
    func scanSuccess(section: Int, row: Int) {
        (self.arrUpdates[section].1 )[row].logisticModel?.status = 1
        self.tableView.reloadData()
    }
}
extension HomeUpdateViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let updates = self.arrUpdates[indexPath.section].1 
        if updates[indexPath.row].type == "dispatche" {
            return 310.0
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let updates = self.arrUpdates[indexPath.section].1
        let updateModel = updates[indexPath.row]
        if (updateModel.type == "dispatche") {
            let logisticModel = updateModel.logisticModel
            if !(logisticModel?.desc.isEmpty)! {
                showAlert((logisticModel?.desc)!, title: (logisticModel?.file_ref)!, controller: self)
            }
        } else {
            let milestoneModel = updateModel.milestoneModel
            if !(milestoneModel?.remark?.isEmpty)! {
                showAlert((milestoneModel?.activity)!, title: (milestoneModel?.activity)!, controller: self)
            }
            
        }
        
    }
}

extension HomeUpdateViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrUpdates.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let updates = self.arrUpdates[section].1 
        return updates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let updates = self.arrUpdates[indexPath.section].1 
        let updateModel = updates[indexPath.row]
        if (updateModel.type == "dispatche") {

            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeUpdateLogisticTableViewCell", for: indexPath) as! HomeUpdateLogisticTableViewCell

            let logisticModel = updateModel.logisticModel
            cell.lblFileName.text = logisticModel?.file_ref
            cell.lblDeliveryStatus.text = Constant.arrLogisticStatus[(logisticModel?.status)!]
            if logisticModel?.status == 1 {
                cell.lblDeliveryStatus.backgroundColor = Constant.colorPrimary
            } else {
                cell.lblDeliveryStatus.backgroundColor = Constant.skyBlue
            }
            //
            cell.lblReceiver.text = logisticModel?.receiver
            cell.lblDescription.text = logisticModel?.desc
            cell.lblDescription2.text = logisticModel?.desc
            cell.lblMethod.text = logisticModel?.address
            cell.lblStatus2.text = Constant.arrLogisticStatus[(logisticModel?.status)!]
            //
            cell.delegate = self
            cell.index = indexPath
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeUpdateTableViewCell", for: indexPath) as! HomeUpdateTableViewCell
            let milestoneModel = updateModel.milestoneModel
            cell.lblName.text = milestoneModel?.activity
            cell.lblStatus.text = milestoneModel?.status
            if milestoneModel?.status == "In Progress" {
                cell.lblStatus.textColor = Constant.red
            } else {
                cell.lblStatus.textColor = Constant.green
            }

            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  self.arrUpdates[section].0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: getScreenSize().width, height: 20))
        view.backgroundColor = Constant.lightGray
        let label = UILabel(frame: CGRect(x: 20, y: 8, width: getScreenSize().width - 40, height: 15))
        label.textColor = UIColor.darkGray
        label.backgroundColor = Constant.lightGray
        label.font = robotoMedium(size: 17)
        label.text = self.arrUpdates[section].0
        view.addSubview(label)
        
        return view
    }

    
}
