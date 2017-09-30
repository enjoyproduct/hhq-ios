//
//  ColorUtils.swift
//  Heyoe
//
//  Created by Admin on 8/26/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
func makeColorFromHex(_ colorString: String) -> UIColor{
    
    var chars = colorString.hasPrefix("#") ? Array(colorString.characters.dropFirst()) : Array(colorString.characters)
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1
    switch chars.count {
    case 3:
        chars = [chars[0], chars[0], chars[1], chars[1], chars[2], chars[2]]
        fallthrough
    case 6:
        chars = ["F","F"] + chars
        fallthrough
    case 8:
        a = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
        r = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
        g = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
        b = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
    default:
        a = 0
    }
    return UIColor(red: r, green: g, blue:  b, alpha: a)
}
