//
//  UIImageView+Extension.swift
//  Pinkstarr
//
//  Created by Admin on 3/3/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
extension UIImageView {
    
    func maskWithColor(color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    func makeRound() {
        self.layer.cornerRadius = self.layer.frame.width / 2
        self.layer.masksToBounds = true
    }
}
