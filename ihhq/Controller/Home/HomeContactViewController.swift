//
//  HomeContactViewController.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class HomeContactViewController: UIViewController, HomeContactTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var expandedRows = Set<IndexPath>()
    var fileModel: FileModel? = nil
    var arrContacts = [ContactModel]()
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "HomeContactTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeContactTableViewCell")
        
        get_contact_list()
    }
    
    func get_contact_list()  {
        
        if self.fileModel == nil {
            return
        }
        self.arrContacts.removeAll()
        
        self.url = API.BASE_API_URL + "files/" + String(describing: self.fileModel!.file_id) + "/contacts"
        
        showProgressHUD()
        APIManager.sendRequest(method: .get, urlString: url, params: nil, succeedHandler: { (result) in
            dismissProgressHUD()
            
            let jsonArray = result.arrayValue
            
            for contact in jsonArray {
                let item = ContactModel(json: contact)
                self.arrContacts.append(item)
            }
            self.tableView.reloadData()
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })
        
    }
    //MARK: HomeContactTableViewCellDelegate method
    func onCall(index: Int) {
        let phonenumber = "+60" + arrContacts[index].mobile.replacingOccurrences(of: " ", with: "")
        UIApplication.shared.open(NSURL(string: "tel://" + phonenumber)! as URL, options: [ : ]) { (result) in
            
        }
    }
    func onEmail(index: Int) {
        // define email address
        let address = self.arrContacts[index].email
        // create the URL
        let url = NSURL(string: "mailto:\(address)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        // load the URL
        UIApplication.shared.open(url! as URL, options: [ : ]) { (result) in
            
        }
    }
}
extension HomeContactViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.expandedRows.contains(indexPath) {
            return 190.0
        }
        return 68.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? HomeContactTableViewCell
            else { return }
        
        switch cell.isExpanded
        {
        case true:
            self.expandedRows.remove(indexPath)
        case false:
            self.expandedRows.insert(indexPath)
        }
        
        cell.isExpanded = !cell.isExpanded
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? HomeContactTableViewCell
            else { return }
        
        self.expandedRows.remove(indexPath)
        
        cell.isExpanded = false
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    
}

extension HomeContactViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeContactTableViewCell") as! HomeContactTableViewCell
        cell.isExpanded = self.expandedRows.contains(indexPath)
        
        let contact = self.arrContacts[indexPath.row]
        cell.lblName.text = contact.name
        cell.lblEmail.text = contact.email
        var phoneNumber = contact.mobile
        //check if first text is 0
        let firstCharacter = contact.mobile[contact.mobile.index(contact.mobile.startIndex, offsetBy: 0)]
        if  firstCharacter == "0" {
            phoneNumber = String(contact.mobile.characters.suffix(contact.mobile.characters.count - 1))
        } else {
            phoneNumber = contact.mobile
        }
        cell.lblPhoneNumber.text = "+60 " + phoneNumber
        cell.lblRole.text = contact.role.capitalized
        cell.delegate = self
        cell.index = indexPath.row
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CONTACT INFO"
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: getScreenSize().width, height: 20))
        view.backgroundColor = Constant.lightGray
        let label = UILabel(frame: CGRect(x: 20, y: 8, width: getScreenSize().width - 40, height: 15))
        label.textColor = UIColor.darkGray
        label.backgroundColor = Constant.lightGray
        label.font = robotoMedium(size: 17)
        label.text = "CONTACT INFO"
        view.addSubview(label)
        
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }

    
}
