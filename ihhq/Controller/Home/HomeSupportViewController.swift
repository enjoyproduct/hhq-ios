//
//  HomeSupportViewController.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class HomeSupportViewController: UIViewController {

   
    @IBOutlet weak var tableView: UITableView!
    var fileModel: FileModel? = nil
    var arrCorrespondences = [CorrespondenceModel]()
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "SupportTableViewCell", bundle: nil), forCellReuseIdentifier: "SupportTableViewCell")
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.arrCorrespondences.removeAll()
        self.tableView.reloadData()
        get_correspondence_list()
    }
    
    func get_correspondence_list()  {
        
        if self.fileModel == nil {
            return
        }
        
        self.url = API.BASE_API_URL + "files/" + String(describing: self.fileModel!.file_id) + "/tickets"
        
        showProgressHUD()
        APIManager.sendRequest(method: .get, urlString: url, params: nil, succeedHandler: { (result) in
            dismissProgressHUD()
            
            let jsonArray = result.arrayValue
            
            for correspondence in jsonArray {
                let item = CorrespondenceModel(json: correspondence)
                self.arrCorrespondences.append(item)
            }
            self.tableView.reloadData()
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })
        
    }


  
}
extension HomeSupportViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.correspondenceModel = self.arrCorrespondences[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeSupportViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCorrespondences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupportTableViewCell") as! SupportTableViewCell
        
        let correspondence = self.arrCorrespondences[indexPath.row]
        cell.lblName.text = correspondence.client_name + "(" + correspondence.category + ")"
        cell.lblDescription.text = correspondence.subject
        cell.lblTime.text = timeFormatter(strTime: correspondence.created_at)
        let imageURL = API.BASE_IMAGE_URL + correspondence.client_photo
        cell.ivAvatar.setImageFromURL(url: imageURL)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CORRESPONDENCE"
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: getScreenSize().width, height: 20))
        view.backgroundColor = Constant.lightGray
        let label = UILabel(frame: CGRect(x: 20, y: 8, width: getScreenSize().width - 40, height: 15))
        label.textColor = UIColor.darkGray
        label.backgroundColor = Constant.lightGray
        label.font = robotoMedium(size: 17)
        label.text = "CORRESPONDENCE"
        view.addSubview(label)
        
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }

    
}
