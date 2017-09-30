//
//  HomeUpdateLogisticTableViewCell.swift
//  ihhq
//
//  Created by Admin on 7/26/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
protocol HomeUpdateLogisticTableViewCellDelegate {
    func onScan(section: Int, row: Int)
}
class HomeUpdateLogisticTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblDeliveryStatus: UILabel!
    @IBOutlet weak var btnQRScan: UIButton!
    @IBOutlet weak var lblQRScan: UILabel!
    @IBOutlet weak var lblDescription2: UILabel!
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var subViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblReceiver: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblMethod: UILabel!
    @IBOutlet weak var lblStatus2: UILabel!
    
    var delegate: HomeUpdateLogisticTableViewCellDelegate? = nil
    var index: IndexPath? = nil
//    var isExpanded:Bool = true
//    {
//        didSet
//        {
//            if !isExpanded {
//                self.subViewHeightConstraint.constant = 0.0
//                self.subView.isHidden = true
//            } else {
//                self.subViewHeightConstraint.constant = 240.0
//                self.subView.isHidden = false
//            }
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblDeliveryStatus.layer.cornerRadius = 4
        self.lblDeliveryStatus.layer.masksToBounds = true
//        if !isExpanded {
//            self.subViewHeightConstraint.constant = 0.0
//            self.subView.isHidden = true
//        }

    }
    @IBAction func onScan(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.onScan(section: (index?.section)!, row: (index?.row)!)
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
