//
//  SupportBaseViewController.swift
//  ihhq
//
//  Created by Admin on 6/18/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SupportBaseViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnSortBy: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var arrCorrespondences = [CorrespondenceModel]()
    var url = ""
    var type = 0//0: unassigned, 1: open, 2: close
    
    var isMenuShow: Bool = false
    var bgMenuView : UIView!
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    var sortBy = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnSortBy.makeRoundCorner(cornerRadius: 4)
        self.searchBar.delegate = self
        self.tableView.register(UINib(nibName: "Support2TableViewCell", bundle: nil), forCellReuseIdentifier: "Support2TableViewCell")
        self.tableView.addInfiniteScrolling {
            self.hideKeyboard()
            self.insertAtBottom()
        }
        self.tableView.addPullToRefresh {
            self.hideKeyboard()
            self.insertAtTop()
            
        }
        
        makeDropDownSortBy()
        if type != 1 {
            self.url = self.getURL()
            self.arrCorrespondences.removeAll()
            get_correspondence_list()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if type == 1 {
            self.url = self.getURL()
            self.arrCorrespondences.removeAll()
            get_correspondence_list()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyboard()
    }
    func hideKeyboard() {
        self.view.endEditing(true)
    }

    func insertAtBottom() {
        self.tableView.infiniteScrollingView.stopAnimating()
        get_correspondence_list()
        if (self.url != "") {
           
        }
        
    }
    func insertAtTop()  {
        self.tableView.pullToRefreshView.stopAnimating()
        
    }
    func makeDropDownSortBy() {
        self.bgMenuView = UIView(frame: CGRect(x: screenWidth - 108, y: 42, width: 100, height: 80))
        self.bgMenuView.backgroundColor = UIColor.gray
        
        //Date button
        let btn_sort_by_date = UIButton(frame: CGRect(x: 0,y: 0,width: 100,height: 40))
        btn_sort_by_date.setTitle(Constant.arrTicketSortBy[0], for: UIControlState())
        btn_sort_by_date.addTarget(self, action: #selector(HomeDocumentViewController.sortByDate(_:)), for: .touchDown)
        btn_sort_by_date.tag = 0
        //Name button
        let btn_sort_by_name = UIButton(frame: CGRect(x: 0,y: 40,width: 100,height: 40))
        btn_sort_by_name.setTitle(Constant.arrTicketSortBy[1], for: UIControlState())
        btn_sort_by_name.addTarget(self, action: #selector(HomeDocumentViewController.sortByName(_:)), for: .touchDown)
        btn_sort_by_name.tag = 0
        //white line
        let viewLine = UIView(frame: CGRect(x: 0, y: 40, width: 100, height: 1))
        viewLine.backgroundColor = UIColor.white
        
        bgMenuView.addSubview(btn_sort_by_date)
        bgMenuView.addSubview(btn_sort_by_name)
        bgMenuView.addSubview(viewLine)
        
    }
    func getURL() -> String {
        switch self.type {
        case 0:
            return API.GET_TICKETS_PENDING
            
        case 1:
            return API.GET_TICKETS_OPEN
            
        case 0:
            return API.GET_TICKETS_CLOSED
            
        default:
            return API.GET_TICKETS_PENDING
        }
    }
    func sortByDate(_ sender: AnyObject) {
        isMenuShow = false
        self.bgMenuView.removeFromSuperview()
        
        self.btnSortBy.setTitle(Constant.arrTicketSortBy[0], for: .normal)
        self.url = self.getURL()
        self.sortBy = 0
        self.arrCorrespondences.removeAll()
        get_correspondence_list()
    }
    func sortByName(_ sender: AnyObject) {
        isMenuShow = false
        self.bgMenuView.removeFromSuperview()
        
        self.btnSortBy.setTitle(Constant.arrTicketSortBy[1], for: .normal)
        self.url = self.getURL()
        self.sortBy = 1
        self.arrCorrespondences.removeAll()
        get_correspondence_list()
    }
    @IBAction func onSortBy(_ sender: UIButton) {
        
        if isMenuShow {
            isMenuShow = false
            self.bgMenuView.removeFromSuperview()
        } else {
            isMenuShow = true
            self.view.addSubview(bgMenuView)
            
        }
        
    }
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        hideKeyboard()
        if (searchBar.text?.characters.count)! > 0 {
            self.url = self.getURL() + "&q=" + searchBar.text!
            
        } else {
            self.url = self.getURL()
        }
        self.arrCorrespondences.removeAll()
        get_correspondence_list()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        if searchBar.text == "" {
//            self.url = self.getURL()
//            self.arrCorrespondences.removeAll()
//            self.tableView.reloadData()
//            get_correspondence_list()
//        }
    }

    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.hideKeyboard()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func get_correspondence_list()  {
        if self.url == "" {
            return
        }
        if self.sortBy == 0 {
            self.url = self.url + "&sort=-date"
        } else if self.sortBy == 1 {
            self.url = self.url + "&sort=subject"
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
            
            for correspondence in jsonArray! {
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
extension SupportBaseViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.correspondenceModel = self.arrCorrespondences[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}

extension SupportBaseViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCorrespondences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Support2TableViewCell") as! Support2TableViewCell
        let correspondence = self.arrCorrespondences[indexPath.row]
        cell.lblName.text = correspondence.client_name + "(" + correspondence.category + ")"
        cell.lblSubject.text = correspondence.subject
        cell.lblTime.text = timeFormatter(strTime: correspondence.created_at)
        cell.lblRef.text = "Ref No: " + correspondence.file_ref!
        let imageURL = API.BASE_IMAGE_URL + correspondence.client_photo
        cell.ivAvatar.makeRound()
        cell.ivAvatar.setImageFromURL(url: imageURL)
        return cell
    }
    
}
