//
//  HomeViewController.swift
//  ihhq
//
//  Created by Admin on 6/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblActiveCount: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    var url = ""
    var arrFiles = [FileModel]()
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setTitle(title: "HHQ TOUCH")
        self.tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        self.tableView.addInfiniteScrolling{
            self.insertAtBottom()
        }
        self.tableView.addPullToRefresh {
            self.insertAtTop()
            
        }

        self.searchBar.delegate = self
        self.url = API.GET_FILES
        
        get_file_list()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyboard()
    }
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    func insertAtBottom() {
        self.tableView.infiniteScrollingView.stopAnimating()
        get_file_list()
        
    }
    func insertAtTop()  {
        self.tableView.pullToRefreshView.stopAnimating()
        
    }

    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        hideKeyboard()
        if (searchBar.text?.characters.count)! > 0 {
            self.url = API.GET_FILES + "&q=" + searchBar.text!
            
        } else {
            self.url = API.GET_FILES
        }
        self.arrFiles.removeAll()
        get_file_list()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            self.url = API.GET_FILES
            self.arrFiles.removeAll()
            get_file_list()
        }
    }

    func get_file_list()  {
        if self.url == "" {
            return
        }
        showProgressHUD()
        APIManager.sendRequest(method: .get, urlString: self.url, params: nil, succeedHandler: { (result) in
            dismissProgressHUD()
            
            if let next_page_url = result["next_page_url"].string {
                self.url = next_page_url
            } else {
                self.url = ""
            }
            self.totalCount = result["total"].int!
            if self.totalCount > 1 {
                self.lblActiveCount.text = String(self.totalCount) + " actives"
            } else {
                self.lblActiveCount.text = String(self.totalCount) + " active"
            }
            
            let files = result["data"].array
            for file in files! {
                let item = FileModel(json: file)
                self.arrFiles.append(item)
            }
            self.tableView.reloadData()
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })
        
    }

}
extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeContainerViewController") as! HomeContainerViewController
        vc.fileModel = self.arrFiles[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension HomeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        let fileModel = self.arrFiles[indexPath.row]
        cell.lblFileName.text = fileModel.project_name
        cell.lblFileRef.text = "File Ref: " + fileModel.file_ref
        let percent = Float(fileModel.percent)!
        cell.progressView.progress = percent / 100
        if  percent <= 25 {
            cell.progressView.tintColor = Constant.red
        } else if percent <= 50 {
            cell.progressView.tintColor = Constant.colorPrimary
        } else if percent <= 75 {
            cell.progressView.tintColor = Constant.lightGreen
        } else {
            cell.progressView.tintColor = Constant.green
        }
        cell.lblPercent.text = fileModel.percent + "%"
        if fileModel.status == 1 {
            cell.lblStatus.text = "Completed"
            
        } else {
            cell.lblStatus.text = "In progress"
            
        }
        return cell
    }
    
    
}

