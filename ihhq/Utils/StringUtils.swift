//
//  StringUtils.swift
//  Heyoe
//
//  Created by Admin on 9/13/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

func makeHashTags(_ arrTags: Array<String>) -> NSMutableArray {
    let newArrTags = NSMutableArray()
    for tag in arrTags {
        newArrTags.add("#" + tag)
    }
    return newArrTags
}
func getMutableAttributedString(originalString: String) -> NSMutableAttributedString {
    do {
        //            let str = try NSAttributedString(data: post.description_!.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSFontAttributeName: UIFont.systemFont(ofSize: 18.0)], documentAttributes: nil)
        
        //            let str = try NSAttributedString(data: post.description_!.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue, NSFontAttributeName: UIFont.systemFont(ofSize: 13.0) ], documentAttributes: nil)
        
        let str = try NSMutableAttributedString(data: (originalString.data(using: String.Encoding.unicode))!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSFontAttributeName: UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightRegular)], documentAttributes: nil)
        
        let fullRange = NSRange(location: 0, length: str.length)
        str.beginEditing()
        str.enumerateAttribute(NSFontAttributeName, in: fullRange, options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired, using: { (attribute, range, stop) in
            if let attributeFont = attribute as? UIFont {
                str.removeAttribute(NSFontAttributeName, range: range)
                let scaledFont = UIFont(descriptor: attributeFont.fontDescriptor, size: attributeFont.pointSize)
//                let scaledFont = UIFont.systemFont(ofSize: attributeFont.pointSize, weight: UIFontWeightRegular)
                str.addAttribute(NSFontAttributeName, value: scaledFont, range: range)
                
            }
            
        })
        str.endEditing()
        return str
        
        
    } catch {
        print(error)
        return NSMutableAttributedString()
    }
    
}

func getFileSize(byte: Int) -> String {
    if byte < 1024 {
        return String(byte) + "b"
    } else if byte < (1024 * 1024) {
        let kb: Double = (Double(byte) / 1024.0).truncate(places: 1)
        return String(kb) + "Kb"
    } else {
        let mb: Double = (Double(byte) / 1024.0 / 1024.0).truncate(places: 1)
        return String(mb) + "Mb"
    }
}
func getUpperCaseFirstLetter(input: String) -> String {
    return input.capitalized
}
func removeFirstLetter(origin: String) -> String {
    return ""
}
func getFileNameFromURL(url: URL) -> String {
    let name = url.lastPathComponent
    return name
}
func getFileExtension(fileName: String) -> String {
    let component = fileName.components(separatedBy: ".")
    return component[component.count - 1]
}
