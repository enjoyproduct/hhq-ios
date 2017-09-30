//
//  UIUtils.swift
//  Heyoe
//
//  Created by Admin on 9/2/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

func getScreenSize() -> CGRect {
    let screenSize: CGRect = UIScreen.main.bounds
    return screenSize
    
}
func robotoMedium(size: CGFloat) -> UIFont {
    return UIFont(name: "Roboto-Medium", size: size)!
}

func robotoLight(size: CGFloat) -> UIFont {
    return UIFont(name: "Roboto-Light", size: size)!
}
