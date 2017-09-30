//
//  UIButton.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func makeRoundCorner(cornerRadius: CGFloat)  {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    func setText(text: String) {
        self.setTitle(text, for: .normal)
    }
}
