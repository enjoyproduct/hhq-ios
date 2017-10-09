//
//  API.swift
//  Heyoe
//
//  Created by Admin on 8/23/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
class API: NSObject {

    static let BASE_URL = "http://hhqtouch.com.my/"

    static let BASE_API_URL = BASE_URL + "api/v1/"
    static let BASE_IMAGE_URL = BASE_URL + "upload/avatars/"
    static let BASE_FILE_URL = BASE_URL + "api/v1/files/documents/"
    static let EMPOWER_URL = "https://hhq.com.my/empower/"
    
    static let REGISTER = BASE_URL + "register"
    static let TERMS_AND_POLICY = "https://hhq.com.my/terms-of-use-for-hhq-touch/"
    static let LOGIN = BASE_API_URL + "users/me"
    static let FORGOT_PASSWORD = BASE_API_URL + "users/me/password"
    static let LOGOUT = BASE_API_URL + "users/me/logout";
    static let GET_FILES = BASE_API_URL + "files?per_page=20";
    static let GET_LOGISTICS = BASE_API_URL + "dispatches";
    static let GET_LOGISTICS_MILESTONES = BASE_API_URL + "files/%d/milestoneslogistics";
    static let GET_TICKETS = BASE_API_URL + "tickets?per_page=20"
    static let GET_TICKETS_OPEN = BASE_API_URL + "tickets/open?per_page=20"
    static let GET_TICKETS_CLOSED = BASE_API_URL + "tickets/close?per_page=20"
    static let GET_TICKETS_PENDING = BASE_API_URL + "tickets/pending?per_page=20"
    static let CREAT_NEW_TICKET = BASE_API_URL + "tickets"
    static let GET_TICKET_MESSAGE = BASE_API_URL + "tickets/"
    static let POST_TICKET_MESSAGE = BASE_API_URL + "tickets/"
    static let GET_TICKET_CATEGORY = BASE_API_URL + "tickets/categories"
    static let GET_FILE_REFS = BASE_API_URL + "users/me/files/file-refs"
    static let GET_NOTIFICATIONS = BASE_API_URL + "notifications"
    static let SUBMIT_QR_CODE = BASE_API_URL + "dispatches/scan"
    static let UPDATE_PROFILE = BASE_API_URL + "users/me/setting"
    static let ENABLE_NOTIFICATION = BASE_API_URL + "enable_notification"
    static let UPLOAD_NEW_DOCUMENT = BASE_API_URL + "files/%d/documents"
    static let CHANGE_PASSWORD = BASE_API_URL + "users/me/change_password"
    static let CREATE_BILL = BASE_API_URL + "billplzpayment"
    static let CHECK_BILLING = BASE_API_URL + "requestbillplz"
    static let UPLOAD_RECEIPT = BASE_API_URL + "bankpayment"
    
    static let DOWNLOAD_INVOICE = BASE_API_URL + "files/invoice/%d/download"
    static let DOWNLOAD_RECEIPT = BASE_API_URL + "files/receipt/%d/download"

}
