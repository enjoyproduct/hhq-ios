//
//  Support2TableViewCell.swift
//  ihhq
//
//  Created by Admin on 6/14/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class Support2TableViewCell: UITableViewCell {

    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRef: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
