//
//  UIImageView.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func makeCirclar()  {
        self.layer.cornerRadius = self.bounds.size.width / 2.0
        self.layer.masksToBounds = true
    }
    func setImageFromURL(url: String) {
        if url.characters.count > 0 {
            self.sd_setImage(with: URL(string:url))
        } else {
            self.image = UIImage(named: "default_user")
        }
    }
    func setCirclarImage(url: String)  {
        self.makeCirclar()
        self.setImageFromURL(url: url)
    }
}
