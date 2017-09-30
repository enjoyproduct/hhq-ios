//
//  DocumentModel.swift
//  ihhq
//
//  Created by Admin on 6/30/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class DocumentModel: NSObject {
    var document_id = 0
    var file_ref = ""
    var name = ""
    var path = ""
    var file_extension = ""
    var file_size = 0
    var created_by = ""
    var created_at = ""
    override init() {
        
    }
    
    init(json: JSON) {
        self.document_id = json["document_id"].int!
      
        self.file_ref = json["file_ref"].string!
        self.name = json["name"].string!
        self.path = json["path"].string!
        self.file_extension = json["extension"].string!
        self.file_size = json["file_size"].int!
        self.created_at = json["created_at"].string!
        if let created = json["created_by"].dictionary {
            self.created_by = (created["name"]?.string)!
        } else {
            
        }
        
        
    }
}
