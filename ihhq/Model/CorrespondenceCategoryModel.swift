//
//  CorrespondenceCategoryModel.swift
//  ihhq
//
//  Created by Admin on 6/30/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CorrespondenceCategoryModel: NSObject {

    var category_id = 0
    var name = ""
   
    override init() {
        
    }
    
    init(json: JSON) {
        self.category_id = json["category_id"].int!
        self.name = json["name"].string!
        
    }
    

}
