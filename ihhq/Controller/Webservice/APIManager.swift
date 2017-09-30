//
//  FeedbackViewController.swift
//  READY
//
//  Created by Admin on 18/03/16.
//  Copyright © 2016 Andrei. All rights reserved.
//

import UIKit

class APIManager: NSObject {

//    class func httpRequest(method: HTTPMethod, url:String,params:NSDictionary, SuccessHandler:@escaping (_ result: JSON) ->Void,Errorhandler:@escaping (_ error:NSError) -> Void){
//        
//        request(url, method: method, parameters: params as? [String : AnyObject]).validate().responseJSON {response in
//            print(response)
//            switch response.result{
//            case .success:
//                if let value = response.result.value {
//                    let json = JSON(value)
//                    SuccessHandler(json)
//                }
//                break
//            case .failure(let error):
//                Errorhandler(error as NSError)
//                break
//                
//            }
//        }
//        
//    }
    
    class func sendRequest(method: HTTPMethod, urlString: String, params: NSDictionary?, succeedHandler: @escaping (_ result: JSON) ->Void, failedHandler: @escaping (_ error:NSError) -> Void)  {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Global.me.token
        ]
        request(urlString, method: method, parameters: params as? Parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { response in
                debugPrint(response)
                print(response.request ?? "")  // original URL request
                print(response.response ?? "") // HTTP URL response
                print(response.data ?? "")     // server data
                print(response.result)   // result of response serialization.
                
                if let statusCode = response.response?.statusCode {
                    print("HTTP response status code is", statusCode);
                    
                    if statusCode == 200 {
                        if let value = response.result.value {
                            let json = JSON(value)
                            succeedHandler(json)
                        }
                        
                    } else {
                        
                        if let value = response.result.value {
                            let dic = JSON(value)
                            let errCode = statusCode
                            let errStr = dic["error"].string ?? ""
                            failedHandler(NSError(domain: errStr, code: errCode, userInfo: [:]))
                        }
                    }
                } else {
                    print("Error : \(String(describing: response.result.error))")
                    failedHandler(response.result.error! as NSError)
                }
            }
            .responseString { (response) in
                print(response)
        }
    }
   
    func downloadFile(urlString: String, fileName: String, succeedHandler: @escaping (_ filePath: String) ->Void, failedHandler: @escaping (_ error:NSError) -> Void)  {

        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent(fileName)
//            
//            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let dirpath: String = paths[0] as String
            let filepath = dirpath + "/" + fileName
            let fileURL = URL(fileURLWithPath: filepath)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Global.me.token
        ]

        download(urlString, headers: headers, to: destination)
            .response { (response) in
                if response.error == nil, let filePath = response.destinationURL?.path {
                    print(filePath)
                    succeedHandler(filePath)
                } else {
                    failedHandler(response.error! as NSError)
                }
        }
    }

}
