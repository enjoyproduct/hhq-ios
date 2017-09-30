//
//  MilestoneModel.swift
//  ihhq
//
//  Created by Admin on 8/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class MilestoneModel: NSObject {

    var id = 0
    var status = ""
    var activity = ""
    var verification: String?
    var duration: String?
    var date = ""
    var percent = ""
    var remark: String?
    
    override init() {
        
    }
    
    init(jsonObject: JSON) {
        self.date = jsonObject["key"].string!
        self.percent = jsonObject["percent"].string!
        let json = jsonObject["id"] as JSON
        self.id = json["no"].int!
        self.status = json["status"].string!
        self.activity = json["activity"].string!
        self.verification = json["verification"].string
        self.duration = json["duration"].string
        if let str = json["remark"].string {
            self.remark = str
        } else {
            self.remark = ""
        }
    }

}
