//
//  HomePaymentTableViewCell.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

protocol HomePaymentTableViewCellDelegate {
    func onViewInvoice(index: Int)
}

class HomePaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPurpose: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblIssueDate: UILabel!
    @IBOutlet weak var lblRemark: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnViewInvoice: UIButton!
    
    var index: Int = 0
    var delegate: HomePaymentTableViewCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblStatus.layer.cornerRadius = 4.0
        lblStatus.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onViewInvoice(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.onViewInvoice(index: self.index)
        }
    }
    
}
