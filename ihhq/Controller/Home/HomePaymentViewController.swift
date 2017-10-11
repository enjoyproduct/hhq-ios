//
//  HomePaymentViewController.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class HomePaymentViewController: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UIActionSheetDelegate {

    @IBOutlet weak var tableView: UITableView!
    var fileModel: FileModel? = nil
    var arrPayments = [PaymentModel]()
    var url = ""
    var billplzEmail = ""
    var selectedIndex = -1
    var isBillCreated = false
    let imagePicker = UIImagePickerController()
    var receiptImage: UIImage? = nil
    
    var fileURL: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "HomePaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "HomePaymentTableViewCell")
        self.imagePicker.delegate = self
        get_payment_list()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isBillCreated {
            checkBilling()
        }
    }
    
    func selectManualOrOnline() {
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "payment method", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let btnManual = UIAlertAction(title: Constant.arrPaymentMethod[0], style: .default)
        { _ in
            self.pickReceiptImage()
        }
        actionSheetControllerIOS8.addAction(btnManual)
        
        let btnBillplz = UIAlertAction(title: Constant.arrPaymentMethod[1], style: .default)
        { _ in
            self.inputBillplzEmail()
        }
        actionSheetControllerIOS8.addAction(btnBillplz)
        
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    func pickReceiptImage() {
        let alert = UIAlertController(title: "Upload Receipt", message: "Upload transaction slip from", preferredStyle: .alert)
       
        alert.addAction(UIAlertAction(title: "Document", style: .default, handler: {  (_) in
            let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypePDF as String, kUTTypeContent as String], in: .import)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            self.present(importMenu, animated: true, completion: nil)

        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {  (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {  (_) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler: {  (_) in
            self.receiptImage = nil
        }))
        self.present(alert, animated: true, completion: nil)

    }
    //pick up pdf, doc and xlsx
    
    // MARK:- UIDocumentPickerDelegate
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        fileURL = url as URL
        self.doUploadReceipt()
    }
    
    @available(iOS 8.0, *)
    // MARK:- UIDocumentMenuDelegate
    public func documentMenu(_ documentMenu:  UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("we cancelled")
        dismiss(animated: true, completion: nil)
    }
    func doUploadReceipt() {
        if self.receiptImage == nil && self.fileURL == nil {
            return
        }
        showProgressHUD()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Global.me.token
        ]
        upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(String(self.arrPayments[self.selectedIndex].payment_id).data(using: String.Encoding.utf8)!, withName: "payment_id")
            multipartFormData.append((self.arrPayments[self.selectedIndex].amount).data(using: String.Encoding.utf8)!, withName: "amount")
            var imageData: Data? = nil
            if self.receiptImage != nil  {
                imageData = UIImageJPEGRepresentation(self.receiptImage!, 0.6)
                multipartFormData.append(imageData!, withName: "receipt", fileName: "receipt.png", mimeType: "image/png")
            } else if self.fileURL != nil {
                let fileName = getFileNameFromURL(url: self.fileURL!)
                let fileExtension = getFileExtension(fileName: fileName)
                var fileData: Data? = nil
                do {
                    fileData = try Data(contentsOf: self.fileURL!)
                    
                } catch {
                    print(error)
                }
                if fileData != nil {
                    multipartFormData.append(fileData!, withName: "receipt", fileName: fileName, mimeType:"application/*")
                }
            }
        }, to: API.UPLOAD_RECEIPT, headers: headers,
           encodingCompletion: { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    dismissProgressHUD()
                    debugPrint(response)
                    if let statusCode = response.response?.statusCode {
                        print("HTTP response status code is", statusCode);
                        
                        if statusCode == 200 {
                            self.arrPayments[self.selectedIndex].status = Constant.arrPaymentStatus[2]
                            self.tableView.reloadData()
                        } else {
                            if let value = response.result.value {
                                let dic = JSON(value)
                                //                                let errCode = statusCode
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
                })
            case .failure(let encodingError):
                dismissProgressHUD()
                print("Encoding Result was FAILURE")
                print(encodingError)
                
            }
        })
    }

    
    func inputBillplzEmail() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Please insert email", message: "", preferredStyle: .alert)
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        // 3. Grab the value from the text field, add action
        alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if textField?.text?.characters.count == 0 {
                showAlert("Please fill email", title: "Error", controller: self)
            } else if !isValidEmail((textField?.text!)!) {
                showAlert("Invalid Email", title: "Warning", controller: self)
                
            } else {
                self.billplzEmail = (textField?.text)!
//                self.selectMethod()
                self.createBill(method: 1)
            }
            
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectMethod() {
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "billing method", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let btnBank = UIAlertAction(title: Constant.arrBillplzMethod[0], style: .default)
        { _ in
            print("btnBank")
            self.createBill(method: 0)
        }
        actionSheetControllerIOS8.addAction(btnBank)
        
        let btnBillplz = UIAlertAction(title: Constant.arrBillplzMethod[1], style: .default)
        { _ in
            print("btnBillplz")
            self.createBill(method: 1)
        }
        actionSheetControllerIOS8.addAction(btnBillplz)
        
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    func createBill(method: Int)  {
        showProgressHUD()
        
        let paramsDict: NSMutableDictionary = [
            "payment_id": String(arrPayments[selectedIndex].payment_id),
            "method": Constant.arrBillplzMethod[method],
            "amount": arrPayments[selectedIndex].amount,
            "email_billpls": billplzEmail,
            "return_url": "http://hhqtouch.com.my"
        ]
        APIManager.sendRequest(method: .post, urlString: API.CREATE_BILL, params: paramsDict, succeedHandler: { (result) in
            dismissProgressHUD()
            if let response = result["status"].string {
                if response == "success" {
                    self.isBillCreated = true
                    let url = result["url"].string
                    self.launchBrowser(billingURL: url!)
                } else {
                    
                }
            } else {
                
            }
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })

    }
    
    func launchBrowser(billingURL: String) {
        UIApplication.shared.open(URL(string: billingURL)!, options: [:], completionHandler: nil)
    }
    
    func checkBilling() {
        showProgressHUD()
        APIManager.sendRequest(method: .get, urlString: API.CHECK_BILLING, params: nil, succeedHandler: { (result) in
            dismissProgressHUD()
            
            if let response = result["status"].string {
                if response == "success" {
                    self.arrPayments[self.selectedIndex].status = Constant.arrPaymentStatus[1]
                    self.tableView.reloadData()
                } else {
                    
                }
            } else {
                
            }

            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })

    }
    
    func get_payment_list()  {
        
        if self.fileModel == nil {
            return
        }
        self.arrPayments.removeAll()
        
        self.url = API.BASE_API_URL + "files/" + String(describing: self.fileModel!.file_id) + "/payments"
        
        showProgressHUD()
        APIManager.sendRequest(method: .get, urlString: url, params: nil, succeedHandler: { (result) in
            dismissProgressHUD()
            
            let jsonArray = result.arrayValue
            
            for payment in jsonArray {
                let item = PaymentModel(json: payment)
                self.arrPayments.append(item)
            }
            self.tableView.reloadData()
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })
        
    }

}

extension HomePaymentViewController : HomePaymentTableViewCellDelegate {
    func onViewInvoice(index: Int) {
        self.downloadFile(index: index)
    }
    func downloadFile(index: Int)  {
        var fileURL = ""
        var fileName = ""
        let payment = self.arrPayments[index]
        if payment.status == Constant.arrPaymentStatus[0] {
            fileURL = String(format: API.DOWNLOAD_INVOICE, self.arrPayments[index].payment_id)
            fileName = String(self.arrPayments[index].payment_id) + "_invoice.pdf"
        } else if payment.status == Constant.arrPaymentStatus[2] {
            fileURL = String(format: API.DOWNLOAD_RECEIPT, self.arrPayments[index].payment_id)
            fileName = String(self.arrPayments[index].payment_id) + "_receipt.pdf"
        } else {
            fileURL = String(format: API.DOWNLOAD_RECEIPT, self.arrPayments[index].payment_id)
            fileName = String(self.arrPayments[index].payment_id) + "_receipt.pdf"
        }
        
        showProgressHUD()
        APIManager().downloadFile(urlString: fileURL, fileName: fileName, succeedHandler: { (filePath) in
            dismissProgressHUD()
            let localPath = filePath.replacingOccurrences(of: " ", with: "%20")
            let localURL = URL(string: localPath)
            //open file
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
            vc.url = localURL
            self.navigationController?.pushViewController(vc, animated: true)
            
        }) { (error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        }
        
    }
}

extension HomePaymentViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Global.me.role == Constant.arrUserRoles[5] && self.arrPayments[indexPath.row].status == Constant.arrPaymentStatus[0]
            && self.fileModel?.assigned_role != Constant.arrUserRoles[6] {
            self.selectedIndex = indexPath.row
            self.selectManualOrOnline()
        }
        
    }
    
}

extension HomePaymentViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPayments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePaymentTableViewCell") as! HomePaymentTableViewCell
        let payment = arrPayments[indexPath.row]
        cell.lblPurpose.text = payment.purpose
        cell.lblAmount.text = payment.currency + payment.amount
        cell.lblIssueDate.text = timeFormatter(strTime: payment.date)
        cell.lblStatus.text = payment.status
        if payment.status == Constant.arrPaymentStatus[0] {
            cell.btnViewInvoice.setText(text: "View Invoice")
            cell.btnViewInvoice.isHidden = false
            cell.btnViewInvoice.isEnabled = true
        } else if payment.status == Constant.arrPaymentStatus[2] {
            cell.btnViewInvoice.setText(text: "View Slip")
            cell.btnViewInvoice.isHidden = false
            cell.btnViewInvoice.isEnabled = true
        } else {
            cell.btnViewInvoice.setText(text: "View Receipt")
            cell.btnViewInvoice.isHidden = false
            cell.btnViewInvoice.isEnabled = true
        }
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "BILLING & PAYMENT"
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: getScreenSize().width, height: 20))
        view.backgroundColor = Constant.lightGray
        let label = UILabel(frame: CGRect(x: 20, y: 8, width: getScreenSize().width - 40, height: 15))
        label.textColor = UIColor.darkGray
        label.backgroundColor = Constant.lightGray
        label.font = robotoMedium(size: 17)
        label.text = "BILLING & PAYMENT"
        view.addSubview(label)
        
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
}
extension HomePaymentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePicker Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let choosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.receiptImage = choosenImage
        self.doUploadReceipt()
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
