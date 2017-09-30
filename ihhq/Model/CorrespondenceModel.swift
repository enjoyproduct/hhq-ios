//
//  CorrespondenceModel.swift
//  ihhq
//
//  Created by Admin on 6/30/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CorrespondenceModel: NSObject {

    var ticket_id = 0
    var file_ref: String?
    var client_id = 0
    var stuff_id = 0
    var category_id = 0
    var status_id = 0
    var subject = ""
    var category = ""
    var created_at = ""
    var client_name = ""
    var client_photo = ""
    override init() {
        
    }
    
    init(json: JSON) {
        self.ticket_id = json["ticket_id"].int!
        self.file_ref = json["file_ref"].string
        self.subject = json["subject"].string!
        self.category = json["category"].string!
        self.created_at = json["created_at"].string!
        if let client = json["client"].dictionary {
            self.client_name = (client["name"]?.string!)!
            self.client_photo = (client["photo"]?.string!)!
           
        }
    }

}
