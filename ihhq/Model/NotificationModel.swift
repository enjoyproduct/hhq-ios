//
//  NotificationModel.swift
//  ihhq
//
//  Created by Admin on 6/30/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class NotificationModel: NSObject {
    var id = 0
    var id_send = 0
    var subject = ""
    var message = ""
    var created_at = ""
    override init() {
        
    }
    
    init(json: JSON) {
        self.id = json["id"].int!
        self.id_send = json["id_send"].int!
        self.subject = json["subject"].string!
        self.message = json["message"].string!
        self.created_at = json["created_at"].string!
        
    }
    
}
