//
//  HomeDocumentViewController.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class HomeDocumentViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSortBy: UIButton!
    @IBOutlet weak var lblDocCount: UILabel!
    @IBOutlet weak var btnUpload: UIButton!
    
    @IBOutlet weak var viewUploadBtnContainer: UIView!
    var isMenuShow: Bool = false
    var bgMenuView : UIView!
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    var sortBy = 0
    
    var fileModel: FileModel? = nil
    var arrDocument = [DocumentModel]()
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "HomeDocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeDocumentTableViewCell")
        self.btnSortBy.makeRoundCorner(cornerRadius: 4)
        self.btnUpload.makeRoundCorner(cornerRadius: 4)
        if Global.me.role == Constant.arrUserRoles[5] || fileModel?.assigned_role == Constant.arrUserRoles[6] {
            self.viewUploadBtnContainer.isHidden = true
            self.btnUpload.isEnabled = false
        } else {
            self.viewUploadBtnContainer.isHidden = false
            self.btnUpload.isEnabled = true
        }
        makeDropDownSortBy()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.get_document_list()
    }
    func makeDropDownSortBy() {
        self.bgMenuView = UIView(frame: CGRect(x: screenWidth - 116, y: 52, width: 100, height: 80))
        self.bgMenuView.backgroundColor = UIColor.gray
        
        //Date button
        let btn_sort_by_date = UIButton(frame: CGRect(x: 0,y: 0,width: 100,height: 40))
        btn_sort_by_date.setTitle(Constant.arrDocSortBy[0], for: UIControlState())
        btn_sort_by_date.addTarget(self, action: #selector(HomeDocumentViewController.sortByDate(_:)), for: .touchDown)
        btn_sort_by_date.tag = 0
        //Name button
        let btn_sort_by_name = UIButton(frame: CGRect(x: 0,y: 40,width: 100,height: 40))
        btn_sort_by_name.setTitle(Constant.arrDocSortBy[1], for: UIControlState())
        btn_sort_by_name.addTarget(self, action: #selector(HomeDocumentViewController.sortByName(_:)), for: .touchDown)
        btn_sort_by_name.tag = 0
        //white line
        let viewLine = UIView(frame: CGRect(x: 0, y: 40, width: 130, height: 1))
        viewLine.backgroundColor = UIColor.white
        
        bgMenuView.addSubview(btn_sort_by_date)
        bgMenuView.addSubview(btn_sort_by_name)
        bgMenuView.addSubview(viewLine)
        
    }
    func sortByDate(_ sender: AnyObject) {
        isMenuShow = false
        self.bgMenuView.removeFromSuperview()

        self.btnSortBy.setTitle(Constant.arrDocSortBy[0], for: .normal)
        self.sortBy = 0
        get_document_list()
    }
    func sortByName(_ sender: AnyObject) {
        isMenuShow = false
        self.bgMenuView.removeFromSuperview()

        self.btnSortBy.setTitle(Constant.arrDocSortBy[1], for: .normal)
        self.sortBy = 1
        get_document_list()
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
    
    @IBAction func onUpload(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadNewDocumentViewController") as! UploadNewDocumentViewController
        vc.fileModel = self.fileModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func get_document_list()  {
        
        if self.fileModel == nil {
            return
        }
        self.arrDocument.removeAll()
        
        self.url = API.BASE_API_URL + "files/" + String(describing: self.fileModel!.file_id) + "/documents"
        if self.sortBy == 0 {
          self.url = self.url + "?sort=date"
        } else if self.sortBy == 1 {
          self.url = self.url + "?sort=name"
        }
        showProgressHUD()
        APIManager.sendRequest(method: .get, urlString: url, params: nil, succeedHandler: { (result) in
            dismissProgressHUD()

            let jsonArray = result.arrayValue
            if jsonArray.count > 1 {
                self.lblDocCount.text = String(describing: jsonArray.count) + " Documents"
            } else {
                self.lblDocCount.text = String(describing: jsonArray.count) + " Document"
            }
            
            for doc in jsonArray {
                let item = DocumentModel(json: doc)
                self.arrDocument.append(item)
            }
            self.tableView.reloadData()
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })
        
    }

    func showDownloadAlert(index: Int) {
        let alertController = UIAlertController(title: Constant.INDECATOR, message: "Do you want to download file?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Download", style: .default) { (action) in
            self.downloadFile(index: index)
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            
        }
    }
    func downloadFile(index: Int)  {
        let fileURL = API.BASE_FILE_URL + String(self.arrDocument[index].document_id) + "/download"
        let fileName = String(self.arrDocument[index].document_id) + "_" + self.arrDocument[index].path.components(separatedBy: "/").last!
        showProgressHUD()
        APIManager().downloadFile(urlString: fileURL, fileName: fileName, succeedHandler: { (filePath) in
            dismissProgressHUD()
            let localPath = filePath.replacingOccurrences(of: " ", with: "%20")
            let localURL = URL(string: localPath)
            //open file
            self.showOpenFileAlert(url: localURL!)
            
        }) { (error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        }

    }
    func showOpenFileAlert(url: URL) {
        let alertController = UIAlertController(title: Constant.INDECATOR, message: "Do you want to open file?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
            self.shareDocument(url: url)
        }
        alertController.addAction(shareAction)
        let OKAction = UIAlertAction(title: "Open", style: .default) { (action) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
            vc.url = url
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {
            
        }
    }
    func shareDocument(url: URL) {
        
        let fileName = url.lastPathComponent
       
        let urlString = "file://" + url.absoluteString
        
        do {
            let docData = try Data(contentsOf: URL(string: urlString)!)
           
            //  create a folder in Application Support
            let applicationSupportDirectory = FileManager.SearchPathDirectory.applicationSupportDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains( applicationSupportDirectory, nsUserDomainMask, true )
            let fileManager = FileManager.default
           
            let path  = paths[0]

            //  check if the folder already exists
            if fileManager.fileExists( atPath: path ) == false
            {
                _ = try? fileManager.createDirectory( atPath: path,
                                                      withIntermediateDirectories: true,
                                                      attributes: nil )
            }
            //  prepare content and write to file
            var destinationPath = "file://" + path + "/" + fileName
            destinationPath = destinationPath.replacingOccurrences(of: " ", with: "%20")
            let destinationURL = URL(string: destinationPath)
            let _ = try docData.write(to: destinationURL!, options: .atomic)
            
            var activityItems: [Any] = []
            activityItems.append(destinationURL)
            activityItems.append("HHQ Attachment")
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            
        } catch {
            print("Unable to load data: \(error)")
        }

        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
extension HomeDocumentViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDownloadAlert(index: indexPath.row)
    }

}

extension HomeDocumentViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDocument.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeDocumentTableViewCell") as! HomeDocumentTableViewCell
        let document = self.arrDocument[indexPath.row]
        switch document.file_extension {
        case Constant.arrDocType[0]:
            cell.ivIcon.image = UIImage(named: "pdf")
            break
        case Constant.arrDocType[1]:
            cell.ivIcon.image = UIImage(named: "doc")
            break
        case Constant.arrDocType[2]:
            cell.ivIcon.image = UIImage(named: "excel")
            break
        default:
            cell.ivIcon.image = UIImage(named: "excel")
            break
        }
        cell.lblName.text = document.name
        cell.lblCreatedBy.text = "by " + document.created_by
        cell.lblDate.text = timeFormatter(strTime: document.created_at, strOutputFormat: "dd MMM YYYY")
        let fileSize = getFileSize(byte: document.file_size)
        cell.lblSize.text = fileSize
        return cell
    }
    
    
}
