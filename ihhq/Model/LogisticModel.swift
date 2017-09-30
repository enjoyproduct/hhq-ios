//
//  LogisticModel.swift
//  ihhq
//
//  Created by Admin on 6/30/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class LogisticModel: NSObject {
    var dispatch_id = 0
    var client_id = 0
    var courier_id = 0
    var courier_name = ""
    var courier_logo = ""
    var file_ref = ""
    var receiver = ""
    var address = ""
    var status = 0
    var qr_code = ""
    var desc = ""
    var created_by = 0
    var created_at = ""
    
    override init() {
        
    }
    
    init(jsonObject: JSON) {
        let json = jsonObject["id"] as JSON
        self.dispatch_id = json["dispatch_id"].int!
        self.status = json["status"].int!
        self.file_ref = json["file_ref"].string!
        self.receiver = json["receiver"].string!
        self.address = json["address"].string!
        self.created_at = json["created_at"].string!
        self.desc = json["description"].string!
    }

}
