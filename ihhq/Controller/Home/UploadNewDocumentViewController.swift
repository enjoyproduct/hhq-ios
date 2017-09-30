//
//  UploadNewDocumentViewController.swift
//  ihhq
//
//  Created by Admin on 6/23/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
//import FileBrowser

protocol UploadNewDocumentViewControllerDelegate {
    func uploadDone(document: DocumentModel)
}

class UploadNewDocumentViewController: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {

    @IBOutlet weak var tfFileName: UITextField!
    @IBOutlet weak var lblFileRef: UILabel!
    @IBOutlet weak var btnBrowse: UIButton!
    
    @IBOutlet weak var btnUploadNow: UIButton!
    
    var fileModel: FileModel? = nil
    
    var delegate: UploadNewDocumentViewControllerDelegate? = nil

    var fileName = ""
    var fileURL: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "UPLOAD A NEW DOCUMENT"
        self.btnUploadNow.makeRoundCorner(cornerRadius: 4)
        
        if self.fileModel != nil {
            self.lblFileRef.text = "File Ref: " + (self.fileModel?.file_ref)!
        }
        
    }
    @IBAction func onUploadNow(_ sender: Any) {
        if self.tfFileName.text == "" {
            showAlert("Please input file name", title: Constant.INDECATOR, controller: self)
            return
        }
        if self.fileURL == nil {
            showAlert("Please choose file", title: Constant.INDECATOR, controller: self)
            return
        }
        self.uploadDocument()
    }
    @IBAction func onBrowseFile(_ sender: Any) {
        let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypePDF as String, kUTTypeContent as String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    //pick up pdf, doc and xlsx
  
    // MARK:- UIDocumentPickerDelegate
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        fileURL = url as URL
        fileName = (fileURL?.lastPathComponent)!
        self.btnBrowse.setTitle(fileName, for: .normal)
//        //for test
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
//        vc.url = url
//        self.navigationController?.pushViewController(vc, animated: true)
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
      
    func uploadDocument() {
        showProgressHUD()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Global.me.token
        ]
        var fileData: Data? = nil
        do {
            fileData = try Data(contentsOf: self.fileURL!, options: NSData.ReadingOptions())
            
        } catch {
            print(error)
        }
        upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(self.fileName.data(using: String.Encoding.utf8)!, withName: "name")
            multipartFormData.append((self.fileModel?.file_ref.data(using: String.Encoding.utf8)!)!, withName: "file_ref")
            if fileData != nil {
                multipartFormData.append(fileData!, withName: "file")
            }
            
        }, to: API.UPLOAD_NEW_DOCUMENT + (self.fileModel?.file_ref)! + "/documents", headers: headers,
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
                            showAlert("Failed to upload", title: "Error", controller: self)
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
