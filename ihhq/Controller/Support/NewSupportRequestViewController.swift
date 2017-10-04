//
//  NewSupportRequestViewController.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class NewSupportRequestViewController: UIViewController, UITextViewDelegate, SelectionTableViewControllerDelegate {

    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var lblWriteMessage: UILabel!
    @IBOutlet weak var keyboardAvoidingView: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var tfSubject: UITextField!
    @IBOutlet weak var lblAvailability: UILabel!
    @IBOutlet weak var lblFileRef: UILabel!
    @IBOutlet weak var lblNoneSelected: UILabel!
    
    @IBOutlet weak var btnFileRef: UIButton!
    @IBOutlet weak var lblDepartment: UILabel!
    @IBOutlet weak var btnDepartment: UIButton!
    
    var arrDepartments = [String]()
    var arrDepartmentIds = [Int]()
    var arrFileRefs = [String]()
    var arrAttachmentURLs = [String]()
    
    var selectedDepartmentID = -1
    var selectedFileRef = ""
    var subject = ""
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "New Correspondence Request"
        self.textview.delegate = self
        self.btnSubmit.makeRoundCorner(cornerRadius: 4)
        self.tfSubject.attributedPlaceholder = NSAttributedString(string: "Subject Matter", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        self.lblWriteMessage.textColor = UIColor.lightGray
        if self.selectedFileRef != "" {
            self.lblAvailability.isHidden = true
            self.lblNoneSelected.text = self.selectedFileRef
            
            self.btnFileRef.isEnabled = false
            self.btnDepartment.isEnabled = false
        }
        KeyboardAvoiding.avoidingView = self.keyboardAvoidingView
        
        getAllFileRef()
        getCorrespondenceCategory()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyboard()
    }
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    @IBAction func onSubmit(_ sender: Any) {
        self.subject = self.tfSubject.text!
        self.message = self.textview.text!
        if self.subject.characters.count == 0 {
            showAlert("Please input subject", title: Constant.INDECATOR, controller: self)
            return
        }
        if self.message.characters.count == 0 {
            showAlert("Please input message", title: Constant.INDECATOR, controller: self)
            return
        }
        if self.selectedDepartmentID < 0 {
            showAlert("Please select department", title: Constant.INDECATOR, controller: self)
            return
        }
        self.submit()
    }
    @IBAction func onAttachFile(_ sender: Any) {
        let vc = SelectionTableViewController()
        vc.arrContents = self.arrAttachmentURLs
        vc.type = 2
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onFileRef(_ sender: Any) {
        let vc = SelectionTableViewController()
        vc.arrContents = self.arrFileRefs
        vc.type = 1
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onDepartment(_ sender: Any) {
        let vc = SelectionTableViewController()
        vc.arrContents = self.arrDepartments
        vc.type = 0
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            self.lblWriteMessage.isHidden = true
        } else {
            self.lblWriteMessage.isHidden = false
        }
    }
    //
    //MARK: SelectionTableViewControllerDelegate
    func selected(index: Int, type: Int) {
        switch type {
        case 0:
            self.selectedDepartmentID = self.arrDepartmentIds[index]
            self.lblDepartment.text = self.arrDepartments[index]
            break
        case 1:
            self.selectedFileRef = self.arrFileRefs[index]
            self.lblNoneSelected.text = self.arrFileRefs[index]
            self.lblAvailability.isHidden = true
            break
        
        default:
            break
        }
    }
    func returnSelectedFileURL(url: String) {
        self.arrAttachmentURLs.append(url)
    }
    //
    func getAllFileRef() {
        showProgressHUD()
        APIManager.sendRequest(method: .get, urlString: API.GET_FILE_REFS, params: nil, succeedHandler: { (result) in
            dismissProgressHUD()

            let jsonArray = result.array
            
            for json in jsonArray! {
                let file_ref = json["file_ref"].string ?? ""
                self.arrFileRefs.append(file_ref)
            }
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })

    }
    func getCorrespondenceCategory() {
        showProgressHUD()
        APIManager.sendRequest(method: .get, urlString: API.GET_TICKET_CATEGORY, params: nil, succeedHandler: { (result) in
            dismissProgressHUD()
            
            
            let jsonArray = result.array
            
            for category in jsonArray! {
                
                let name = category["name"].string ?? ""
                self.arrDepartments.append(name)
                let category_id = category["category_id"].int ?? 0
                self.arrDepartmentIds.append(category_id)
                
                if category_id == self.selectedDepartmentID {
                    self.lblDepartment.text = name
                }
            }
            if self.selectedDepartmentID < 0 {
                self.selectedDepartmentID = self.arrDepartmentIds[0]
                self.lblDepartment.text = self.arrDepartments[0]
            }
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })

    }
    func submit() {
        showProgressHUD()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Global.me.token
        ]
        var arrAttachments = [Data]()
        for fileUrl in self.arrAttachmentURLs {
            let attachment_url = URL(string: fileUrl)
            
            do {
                let attachmentData = try Data(contentsOf: attachment_url!)
                arrAttachments.append(attachmentData)
                // do something with data
                // if the call fails, the catch block is executed
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
        upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(String(self.selectedDepartmentID).data(using: String.Encoding.utf8)!, withName: "department_id")
            multipartFormData.append(self.subject.data(using: String.Encoding.utf8)!, withName: "subject")
            multipartFormData.append(self.message.data(using: String.Encoding.utf8)!, withName: "message")
            if self.selectedFileRef != "" {
                multipartFormData.append(self.selectedFileRef.data(using: String.Encoding.utf8)!, withName: "file_ref")
            }
            for attachment in arrAttachments {
                multipartFormData.append(attachment, withName: "attachments[]")
            }
        }, to: API.CREAT_NEW_TICKET, headers: headers,
           encodingCompletion: { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    dismissProgressHUD()
                    debugPrint(response)
                    if let statusCode = response.response?.statusCode {
                        print("HTTP response status code is", statusCode);
                        
                        if statusCode == 200 {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            if let value = response.result.value {
                                let dic = JSON(value)
                                
                                let errStr = dic["error"].string
                                showAlert(errStr!, title: "Error", controller: self)
                            }
                        }
                    } else {
                        print("Error : \(String(describing: response.result.error))")
                        showAlert(response.result.error as! String, title: "Error", controller: self)
                    }
                    
                })
                upload.responseString(completionHandler: { (response) in
                    dismissProgressHUD()
                    debugPrint(response)
                    self.navigationController?.popViewController(animated: true)
                })
            case .failure(let encodingError):
                dismissProgressHUD()
                print("Encoding Result was FAILURE")
                print(encodingError)
                
            }
        })

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
