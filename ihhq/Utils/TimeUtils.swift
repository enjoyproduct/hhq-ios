//
//  TimeUtils.swift
//  Heyoe
//
//  Created by Admin on 9/12/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
var currentTimestamp: TimeInterval {
    return Date().timeIntervalSince1970
}
func getEllapsedTime(_ oldTimestamp: Int) -> String {
    var strTime = ""
    let delta = Int(currentTimestamp) - oldTimestamp
    if delta < 0  {
        strTime = "0 " + ("minute_ago")
    } else if delta / 60 < 60 {
        let time = delta / 60
        if time <= 1 {
            strTime = String(time) + " " + ("minute_ago")
        } else {
            strTime = String(time) + " " + ("minutes_ago")
        }
    } else if delta / 3600 < 24 {
        let time = delta / 3600
        if time <= 1 {
            strTime = String(time) + " " + ("hour_ago")
        } else {
            strTime = String(time) + " " + ("hours_ago")
        }

    } else if delta / (3600 * 24) < 7 {
        let time = delta / (3600 * 24)
        if time <= 1 {
            strTime = String(time) + " " + ("day_ago")
        } else {
            strTime = String(time) + " " + ("days_ago")
        }
    } else if delta / (3600 * 24 * 7) < 4 {
        let time = delta / (3600 * 24 * 7)
        if time <= 1 {
            strTime = String(time) + " " + ("week_ago")
        } else {
            strTime = String(time) + " " + ("weeks_ago")
        }
    } else if delta / (3600 * 24 * 30) < 12 {
        let time = delta / (3600 * 24 * 30)
        if time <= 1 {
            strTime = String(time) + " " + ("monthe_ago")
        } else {
            strTime = String(time) + " " + ("monthes_ago")
        }
    } else {
        let time = delta / (3600 * 24 * 365)
        if time <= 1 {
            strTime = String(time) + " " + ("year_ago")
        } else {
            strTime = String(time) + " " + ("years_ago")
        }
    }
    return strTime
}
func timeFormatter(strTime: String, strInputFormat: String = "", strOutputFormat: String = "") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    dateFormatter.dateFormat = strInputFormat != "" ? strInputFormat : "yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from: strTime)
    dateFormatter.dateFormat = strOutputFormat != "" ? strOutputFormat : "dd MMM YYYY"
    let outputString = dateFormatter.string(from: date!)
    return outputString
}
func getDateFromString(strTime: String, strInputFormat: String = "") -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    dateFormatter.dateFormat = strInputFormat != "" ? strInputFormat : "yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from: strTime)
    return date!
}
