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
            
            self.createBill()
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
                print(encodingError)
                
            }
        })
    }

    

    func createBill() {
        showProgressHUD()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Global.me.token
        ]
        
        upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(String(self.arrPayments[self.selectedIndex].payment_id).data(using: String.Encoding.utf8)!, withName: "payment_id")
           
        }, to: API.CREATE_BILL, headers: headers,
           encodingCompletion: { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    dismissProgressHUD()
                    debugPrint(response)
                    if let statusCode = response.response?.statusCode {
                        print("HTTP response status code is", statusCode);
                        if let value = response.result.value {
                            let jsonResponse = JSON(value)
                            if statusCode == 200 {
                                if let status = jsonResponse["status"].string {
                                    if status == "success" {
                                        self.isBillCreated = true
                                        let url = jsonResponse["url"].string
                                        self.launchBrowser(billingURL: url!)
                                        
                                    } else {
                                        
                                    }
                                } else {
                                    
                                }

                            } else {
                                let errStr = jsonResponse["error"].string
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
                print(encodingError)
            }
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
        let payment = self.arrPayments[index]
        var fileURL = ""
        var fileName = ""
        if !payment.officalReceiptFilePath.isEmpty {
            fileURL = String(format: API.DOWNLOAD_OFFICIAL_RECEIPT, self.arrPayments[index].payment_id)
            fileName = payment.officalReceiptFilePath.components(separatedBy: "/").last!
        } else if !payment.receiptFilePath.isEmpty && payment.status != Constant.arrPaymentStatus[0] {
            fileURL = String(format: API.DOWNLOAD_RECEIPT, self.arrPayments[index].payment_id)
            fileName = payment.receiptFilePath.components(separatedBy: "/").last!
        } else if !payment.invoiceFilePath.isEmpty{
            fileURL = String(format: API.DOWNLOAD_INVOICE, self.arrPayments[index].payment_id)
            fileName = payment.invoiceFilePath.components(separatedBy: "/").last!
        } else {
            return
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
        if Global.me.role == Constant.arrUserRoles[5]
            && self.arrPayments[indexPath.row].status == Constant.arrPaymentStatus[0]
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
