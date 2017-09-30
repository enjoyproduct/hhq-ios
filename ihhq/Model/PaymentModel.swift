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
    var status = ""
    var date = ""
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
        self.status = json["status"].string!
        self.date = json["created_at"].string!
        
        
    }

}
