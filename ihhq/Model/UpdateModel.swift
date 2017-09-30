//
//  UpdateModel.swift
//  ihhq
//
//  Created by Admin on 8/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class UpdateModel: NSObject {

    var milestoneModel: MilestoneModel? = nil
    var logisticModel: LogisticModel? = nil
    var type = ""
    var date = ""
    
    override init() {
        
    }
    
    init(jsonObject: JSON) {
        self.date = jsonObject["key"].string!
        self.type = jsonObject["type"].string!
        if type == "milestone" {
            self.milestoneModel = MilestoneModel(jsonObject: jsonObject)
        } else {
            self.logisticModel = LogisticModel(jsonObject: jsonObject)
        }
    }

}
