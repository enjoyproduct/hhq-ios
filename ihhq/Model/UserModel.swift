//
//  UserModel.swift
//  ihhq
//
//  Created by Admin on 6/30/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    var id = 0
    var country_id = 0
    var department_id = 0
    var office_id = 0
    var name = ""
    var company_number = ""
    var passport_no = ""
    var email = ""
    var mobile = ""
    var verified = 0
    var is_allow = 0
    var is_review = 0
    var photo = ""
    var address = ""
    var is_enable_push = 0
    var is_enable_email = 0
    var token = ""
    var role = ""
    var password = ""
    override init() {
        
    }
    init (json: JSON) {
        self.id = json["id"].int!
        self.country_id = json["country_id"].int!
        self.office_id = json["office_id"].int!
        self.department_id = json["department_id"].int!
        self.name = json["name"].string!
        self.company_number = json["company_number"].string!
        self.passport_no = json["passport_no"].string!
        self.email = json["email"].string!
        self.mobile = json["mobile"].string!
        self.photo = json["photo"].string!
        self.address = json["address"].string!
        self.token = json["token"].string!
        self.role = json["role"].string!
        self.is_enable_push = json["is_enable_push"].int!
        self.is_enable_email = json["is_enable_email"].int!
        self.verified = json["verified"].int!
        self.is_allow = json["is_allow"].int!
        self.is_review = json["is_review"].int!
    }
    
}
