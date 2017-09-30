//
//  HomeContactTableViewCell.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

protocol HomeContactTableViewCellDelegate {
    func onCall(index: Int)
    func onEmail(index: Int)
}
class HomeContactTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var subViewHeightConstraint: NSLayoutConstraint!
    
    var delegate: HomeContactTableViewCellDelegate? = nil
    var index: Int = -1
    
    var isExpanded:Bool = false
    {
        didSet
        {
            if !isExpanded {
                self.subViewHeightConstraint.constant = 0.0
                self.subView.isHidden = true
            } else {
                self.subViewHeightConstraint.constant = 122.0
                self.subView.isHidden = false
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnCall.layer.cornerRadius = 4
        self.btnCall.layer.masksToBounds = true
        self.btnEmail.layer.cornerRadius = 4
        self.btnEmail.layer.masksToBounds = true
        
        if !isExpanded {
            self.subViewHeightConstraint.constant = 0.0
            self.subView.isHidden = true
        }
    }
    @IBAction func onCall(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.onCall(index: self.index)
        }
    }
    @IBAction func onEmail(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.onEmail(index: self.index)
        }

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
