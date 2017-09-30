//
//  ScanQRCodeViewController.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AVFoundation
protocol ScanQRCodeViewControllerDelegate {
    func scanSuccess(section: Int, row: Int)
}
class ScanQRCodeViewController: BaseViewController, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var tvResult: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var dispatch_id: Int = 0
    var url = ""
    var file_ref = ""
    var section = 0
    var row = 0
    var delegate: ScanQRCodeViewControllerDelegate? = nil
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
            $0.showTorchButton = true
            $0.showOverlayView = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - Actions
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController?
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert?.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        }
                    }
                }))
                
                alert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            case -11814:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert?.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            default:
                alert = nil
            }
            
            guard let vc = alert else { return false }
            
            present(vc, animated: true, completion: nil)
            
            return false
        }
    }

    func scanInModalAction() {
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        present(readerVC, animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: nil)
//        self.tvResult.text = String (format:"%@ (of type %@)", result.value, result.metadataType)
        self.tvResult.text = result.value

        self.btnSubmit.isHidden = false
        self.btnSubmit.isEnabled = true
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setTitle(title: "SCAN QR CODE")
        btnScan.makeRoundCorner(cornerRadius: 4)
        btnSubmit.makeRoundCorner(cornerRadius: 4)
        self.btnSubmit.isEnabled = false
        
        self.scanInModalAction()
    }
    @IBAction func onScan(_ sender: Any) {
        self.scanInModalAction()
    }
    @IBAction func onSubmit(_ sender: Any) {
        let qrCode = self.tvResult.text
        if (qrCode?.characters.count)! > 0 {
            self.submitCode(qrCode: qrCode!)
        }
    }
    
    
    func submitCode(qrCode: String)  {
        
        showProgressHUD()
        let url = API.SUBMIT_QR_CODE
        let paramsDict: NSMutableDictionary = [
            "qr_code": qrCode]
        APIManager.sendRequest(method: .post, urlString: url, params: paramsDict, succeedHandler: { (result) in
            dismissProgressHUD()
            showAlert("Submit success", title: Constant.INDECATOR, controller: self)
            if self.delegate != nil {
                self.delegate?.scanSuccess(section: self.section, row: self.row)
                self.navigationController?.popViewController(animated: true)
            }
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
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
