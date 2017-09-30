//
//  Double.swift
//  ihhq
//
//  Created by Admin on 9/14/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

extension Double {
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
