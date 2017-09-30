//
//  ContactModel.swift
//  ihhq
//
//  Created by Admin on 6/30/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ContactModel: NSObject {
    var id = 0
    var email = ""
    var mobile = ""
    var name = ""
    var role = ""
    var country_id = 0

    override init() {
        
    }
    
    init(json: JSON) {
        self.id = json["id"].int!
        self.email = json["email"].string!
        self.mobile = json["mobile"].string!
        self.name = json["name"].string!
        self.role = json["role"].string!
        self.country_id = json["country_id"].int!
    }

}
