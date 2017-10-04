//
//  FileModel.swift
//  ihhq
//
//  Created by Admin on 6/30/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

struct CaseModel {
    var no = 0
    var select = false
    var status = ""
    var activity = ""
    var duration = 0
    var milestone = 0.0
    
}
class FileModel: NSObject {
    var file_id = 0
    var category_id = 0
    var sub_category_id = 0
    var type_id = 0
    var file_ref = ""
    var project_name = ""
    var subject_matter = ""
    var subject_description: String?
    var contact_name: String?
    var contact: String?
    var contact_email: String?
    var introducer: String?
    var status = 0
    var cases = [CaseModel]()
    var percent = ""
    var billplz_collection_id: String?
    var currency: String?
    var outstanding_amount = ""
    var paid_amount = ""
    var residential_address: String?
    var mailing_address: String?
    var created_by = 0
    var updated_by = 0
    var closed_by = 0
    var tags = [String]()
    var assigned_role = ""
    
    override init() {
        
    }
   
    init(json: JSON) {
        self.file_id = json["file_id"].int!
        self.category_id = json["category_id"].int!
        self.sub_category_id = json["sub_category_id"].int!
        self.type_id = json["type_id"].int!
        self.file_ref = json["file_ref"].string!
        self.project_name = json["project_name"].string!
        self.subject_matter = json["subject_matter"].string!
        self.subject_description = json["subject_description"].string
        self.contact_name = json["contact_name"].string
        self.contact = json["contact"].string
        self.contact_email = json["contact_email"].string
        self.introducer = json["introducer"].string
        self.status = json["status"].int!
        if json["cases"] != nil {
            
        }
        self.percent = json["percent"].string!
        self.billplz_collection_id = json["billplz_collection_id"].string
        self.currency = json["currency"].string!
        self.outstanding_amount = json["outstanding_amount"].string!
        self.paid_amount = json["paid_amount"].string!
        self.residential_address = json["residential_address"].string
        self.mailing_address = json["mailing_address"].string
        self.created_by = json["created_by"].int!
        self.updated_by = json["updated_by"].int!
        self.closed_by = json["closed_by"].int!
        let tagString = json["tags"].string!
        self.tags = tagString.components(separatedBy: ",")
        
        if let role = json["role"].string {
            self.assigned_role = role;
        } else {
            self.assigned_role = Constant.arrUserRoles[0]
        }
        
        
    }
}

