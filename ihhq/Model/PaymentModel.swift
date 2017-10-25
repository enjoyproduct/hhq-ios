//
//  PaymentModel.swift
//  ihhq
//
//  Created by Admin on 6/30/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class PaymentModel: NSObject {
    var payment_id = 0
    var file_ref = ""
    var transaction_id = 0
    var purpose = ""
    var amount = ""
    var currency = ""
    var remarks: String?
    var status: String?
    var date = ""
    var invoiceFilePath = ""
    var receiptFilePath = ""
    var officalReceiptFilePath = ""
    override init() {
        
    }
    
    init(json: JSON) {
        self.payment_id = json["payment_id"].int!
        self.file_ref = json["file_ref"].string!
        self.transaction_id = json["transaction_id"].int!
        self.purpose = json["purpose"].string!
        self.amount = json["amount"].string!
        self.currency = json["currency"].string!
        self.remarks = json["remarks"].string
        self.date = json["created_at"].string!
        self.status = json["status_detail"].string
        if let invoice = json["invoice"].string {
            self.invoiceFilePath = invoice
        } else {
            
        }
        if let receipt = json["receipt"].string {
            self.receiptFilePath = receipt
        } else {
            
        }
        if let officalReceipt = json["receipt_office"].string {
            self.officalReceiptFilePath = officalReceipt
        } else {
            
        }
        
    }

}
