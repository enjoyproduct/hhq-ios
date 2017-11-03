//
//  ChatViewController.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
class ChatViewController: JSQMessagesViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var messages = [JSQMessage]()
    
    var conversation: Conversation?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    fileprivate var displayName: String!
    
    var correspondenceModel: CorrespondenceModel? = nil
    var url_get_message = ""
    var url_post_message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.senderId = self.getSenderId()
        self.senderDisplayName = self.getSenderDisplayName()
        //set title
        if self.correspondenceModel != nil {
            self.setTitle(title: (self.correspondenceModel?.client_name)! + " (" + (self.correspondenceModel?.category)! + ") \n Ref: " +  (self.correspondenceModel?.file_ref)!)
            self.url_get_message = API.GET_TICKET_MESSAGE + String(describing: self.correspondenceModel!.ticket_id) + "/messages?per_page=60"
            self.url_post_message = API.POST_TICKET_MESSAGE + String(describing: self.correspondenceModel!.ticket_id) + "/messages"
        }
        self.setupRightButton()// to centerize title
        // Bubbles with tails
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: Constant.colorPrimary)
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
        /**
         *  on showing or removing Avatars based on user settings.
         */
        
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        // This is a beta feature that mostly works but to make things more stable it is diabled.
        collectionView?.collectionViewLayout.springinessEnabled = false
        
        automaticallyScrollsToMostRecentMessage = true
        
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
        ///
        self.getTicketMessages()
        
    }
    func setTitle(title: String) {
        let label = UILabel(frame: CGRect(x:40, y:0, width:getScreenSize().width - 40, height:50))
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 3
        label.font = robotoMedium(size: 15)
        label.textAlignment = .center
        label.textColor = Constant.colorPrimary
        label.text = title
        self.navigationItem.titleView = label
    }

    func setupRightButton() {
        let backButton = UIBarButtonItem(title: "   ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = backButton
        
    }
    func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func getTicketMessages()  {
        if self.url_get_message == "" {
            return
        }
        self.messages.removeAll()
        showProgressHUD()
        APIManager.sendRequest(method: .get, urlString: self.url_get_message, params: nil, succeedHandler: { (result) in
            dismissProgressHUD()
            
            if let next_page_url = result["next_page_url"].string {
                self.url_get_message = next_page_url
            } else {
                self.url_get_message = ""
            }
            
            let jsonArray = result["data"].array
            
            for json in jsonArray! {
//                let message_id = json["message_id"].int
//                let type = json["message_id"].int
//                let ticket_id = json["ticket_id"].int
                let sender_id = json["sender_id"].int!
//                let client_id = json["client_id"].int
                
//                let status = json["status"].int
                let name = json["name"].string
//                let photo = json["photo"].string
                let created_at = json["created_at"].string
                let date = getDateFromString(strTime: created_at!)
                let message = json["message"].string
//                message = message?.replacingOccurrences(of: "\\", with: "")
                let message_json = JSON.parse(message!)
                let message_str = message_json["text"].string
                //add text message
                let textMessage = JSQMessage(senderId: String(describing: sender_id), senderDisplayName: name, date: date, text: message_str)
                if (message_str?.characters.count)! > 0 {
                    self.messages.append(textMessage!)
                }
                
                //add attachment message
                if let message_attachments = message_json["attachments"].array {
                    
                    for attachment in message_attachments {
                        let fileName = attachment["name"].string
                        let path = attachment["path"].string
    //                    let size = attachment["size"].string
//                        let fileNameMessage = JSQMessage(senderId: String(describing: sender_id), senderDisplayName: fileName, date: date, text: message_str)
//                        self.messages.append(fileNameMessage!)
                        //
                        var image: UIImage?
                        
                        if (fileName?.contains(".pdf"))! {
                            image = UIImage(named: "message_pdf")
                        } else if ((fileName?.contains(".doc"))! || (fileName?.contains(".word"))!) {
                            image = UIImage(named: "message_doc")
                        } else if (fileName?.contains(".xls"))! {
                            image = UIImage(named: "message_xlsx")
                        } else if ((fileName?.contains(".png"))! || (fileName?.contains(".jpg"))! || (fileName?.contains(".jpeg"))!){
                            image = UIImage(named: "picture")
                        } else {
                            image = UIImage(named: "message_pdf")
                        }

                        let downloadURL = String(format: API.DOWNLOAD_TICKET_FILE, path!, fileName!)
                        let photoItem = JSQPhotoMediaItem(image: image)
                        let attchMessage = JSQMessage(senderId: String(describing: sender_id), senderDisplayName: downloadURL, date: date , media: photoItem)
                        
                        self.messages.append(attchMessage!)
                    }
                }
                
            }
            self.collectionView.reloadData()
            
        }, failedHandler: {(error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        })
        
    }
    func sendMessage(message: String) {
        showProgressHUD()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Global.me.token
        ]
        upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(message.data(using: String.Encoding.utf8)!, withName: "message")
            
        }, to: self.url_post_message, headers: headers,
           encodingCompletion: { (encodingResult) in
            dismissProgressHUD()
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    debugPrint(response)
                    if let statusCode = response.response?.statusCode {
                        print("HTTP response status code is", statusCode);
                        if statusCode == 200 {
                            
                        } else {
                            if let value = response.result.value {
                                let dic = JSON(value)
                                let errStr = dic["error"].string
                                showAlert(errStr!, title: "Error", controller: self)
                            }
                        }
                    } else {
                        print("Error : \(String(describing: response.result.error))")
                    }
                    
                })
                upload.responseString(completionHandler: { (response) in
                    debugPrint(response)
                })
            case .failure(let encodingError):
                print("Encoding Result was FAILURE")
                print(encodingError)
                
            }
        })
    }
    
    func sendAttachment(attachment_url: URL) {
        showProgressHUD()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Global.me.token
        ]
        var attachmentData: Data? = nil
        do {
            attachmentData = try Data(contentsOf: attachment_url)
        } catch {
            print(error.localizedDescription)
        }
        upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append("".data(using: String.Encoding.utf8)!, withName: "message")
            if attachmentData != nil {
                let fileName = getFileNameFromURL(url: attachment_url)
                multipartFormData.append(attachmentData!, withName: "attachments", fileName: fileName, mimeType: "application/*")
            }
        }, to: self.url_post_message, headers: headers,
           encodingCompletion: { (encodingResult) in
            dismissProgressHUD()
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    debugPrint(response)
                    if let statusCode = response.response?.statusCode {
                        print("HTTP response status code is", statusCode);
                        if statusCode == 200 {
                            if let value = response.result.value {
                                let dic = JSON(parseJSON: value)
                                let message = dic["message"].string
                                let messageJSON = JSON.parse(message!)
                                if messageJSON["attachments"].array != nil {
                                    let attachments = messageJSON["attachments"].array
                                    if (attachments?.count)! > 0 {
                                        let name = attachments?[0]["name"].string
                                        let path = attachments?[0]["path"].string
                                        let downloadURL = String(format: API.DOWNLOAD_TICKET_FILE, path!, name!)
                                        let lastMessage = self.messages.last
                                        let newMessage = JSQMessage(senderId: self.getSenderId(), senderDisplayName: downloadURL, date: Date() , media: lastMessage?.media)
                                        self.messages.removeLast()
                                        self.messages.append(newMessage!)
                                        self.finishSendingMessage(animated: true)
                                    }
                                }
                            }

                        } else {
                            if let value = response.result.value {
                                let dic = JSON(value)
                                let errStr = dic["error"].string
                                showAlert(errStr!, title: "Error", controller: self)
                                self.messages.removeLast()
                                self.finishSendingMessage(animated: true)
                            }
                        }
                    } else {
                        print("Error : \(String(describing: response.result.error))")
                        showAlert(response.result.error as! String, title: "Error", controller: self)
                    }
                })
                upload.responseString(completionHandler: { (response) in
                    debugPrint(response)
                })
            case .failure(let encodingError):
                print("Encoding Result was FAILURE")
                print(encodingError)
            }
        })

    }
    // MARK:- UIDocumentPickerDelegate
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        if FileManager.default.fileExists(atPath: url.path) {
            print("The Url is : /(url)")
            self.sendAttachment(attachment_url: url)
            let path = url.path
            var image: UIImage?
            if (path.contains(".pdf")) {
                image = UIImage(named: "message_pdf")
            } else if (path.contains(".doc") || path.contains(".word")) {
                image = UIImage(named: "message_doc")
            } else if (path.contains(".xls")) {
                image = UIImage(named: "message_xlsx")
            } else if (path.contains(".png") || path.contains(".jpg") || path.contains(".jpeg")){
                image = UIImage(named: "picture")
            } else {
                image = UIImage(named: "pdf")
            }
            let photoItem = JSQPhotoMediaItem(image: image)
            let attchMessage = JSQMessage(senderId: getSenderId(), senderDisplayName: getSenderDisplayName(), date: Date() , media: photoItem)
            self.messages.append(attchMessage!)
            self.finishSendingMessage(animated: true)
            
        }
        
    }
    @available(iOS 8.0, *)
    // MARK:- UIDocumentMenuDelegate
    public func documentMenu(_ documentMenu:  UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        print("Cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: JSQMessagesViewController method overrides
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        /**
         *  Sending a message. Your implementation of this method should do *at least* the following:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishSendingMessage`
         */
        if text.characters.count > 0 {
            sendMessage(message: text)
        } else {
            return
        }
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages.append(message!)
        self.finishSendingMessage(animated: true)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        self.inputToolbar.contentView!.textView!.resignFirstResponder()
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypePDF as String, kUTTypeContent as String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func buildVideoItem() -> JSQVideoMediaItem {
        let videoURL = URL(fileURLWithPath: "file://")
        
        let videoItem = JSQVideoMediaItem(fileURL: videoURL, isReadyToPlay: true)
        
        return videoItem!
    }
    
    func buildAudioItem() -> JSQAudioMediaItem {
        let sample = Bundle.main.path(forResource: "jsq_messages_sample", ofType: "m4a")
        let audioData = try? Data(contentsOf: URL(fileURLWithPath: sample!))
        
        let audioItem = JSQAudioMediaItem(data: audioData)
        
        return audioItem
    }
    
    func buildLocationItem() -> JSQLocationMediaItem {
        let ferryBuildingInSF = CLLocation(latitude: 37.795313, longitude: -122.393757)
        
        let locationItem = JSQLocationMediaItem()
        locationItem.setLocation(ferryBuildingInSF) {
            self.collectionView!.reloadData()
        }
        
        return locationItem
    }
    
    func addMedia(_ media:JSQMediaItem) {
        let message = JSQMessage(senderId: self.getSenderId(), displayName: self.getSenderDisplayName(), media: media)
        self.messages.append(message!)
        
        //Optional: play sent sound
        
        self.finishSendingMessage(animated: true)
    }
    
    
    //MARK: JSQMessages CollectionView DataSource
    
    func getSenderId() -> String {
        return String(Global.me.id)
    }
//
    func getSenderDisplayName() -> String {
        return Global.me.name
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        
        return messages[indexPath.item].senderId == self.getSenderId() ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = messages[indexPath.item]
        return getAvatar(message.senderId)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        if (indexPath.item % 3 == 0) {
            let message = self.messages[indexPath.item]
            let date = JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
            
            return date
        }
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        // Displaying names above messages
        //Mark: Removing Sender Display Name
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         */
        
        if message.senderId == self.getSenderId() {
            return nil
        }
        
        return NSAttributedString(string: message.senderDisplayName)
    }
    
   //show date once per 3 messages
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    //show/hide user name label
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         */

        /**
         *  iOS7-style sender name labels
         */
        let currentMessage = self.messages[indexPath.item]
        
        if currentMessage.senderId == self.getSenderId() {
            return 0.0
        }
        if currentMessage.media != nil {
            return 0.0
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    //select message
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let currentMessage = self.messages[indexPath.row]
        if currentMessage.media != nil {
            self.downloadFile(endPoint: currentMessage.senderDisplayName)
        } else {
            
        }
    }
    
    
    func downloadFile(endPoint: String)  {
        
        let fileName = endPoint.components(separatedBy: "=").last
        showProgressHUD()
        APIManager().downloadFile(urlString: endPoint, fileName: fileName!, succeedHandler: { (filePath) in
            dismissProgressHUD()
            let localPath = filePath.replacingOccurrences(of: " ", with: "%20")
            let localURL = URL(string: localPath)
            //open file
            self.showOpenFileAlert(url: localURL!)
            
        }) { (error) in
            dismissProgressHUD()
            print(error)
            showAlert(error.domain, title: "Error : " + String(error.code), controller: self)
        }
        
    }
    func showOpenFileAlert(url: URL) {
        let alertController = UIAlertController(title: Constant.INDECATOR, message: "", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
            self.shareDocument(url: url)
        }
        alertController.addAction(shareAction)
        let OKAction = UIAlertAction(title: "Open to View", style: .default) { (action) in
            self.openFile(url: url)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {
            
        }
    }
    func openFile(url: URL) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        vc.url = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func shareDocument(url: URL) {
        
        let fileName = url.lastPathComponent
        
        let urlString = "file://" + url.absoluteString
        
        do {
            let docData = try Data(contentsOf: URL(string: urlString)!)
            
            //  create a folder in Application Support
            let applicationSupportDirectory = FileManager.SearchPathDirectory.applicationSupportDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains( applicationSupportDirectory, nsUserDomainMask, true )
            let fileManager = FileManager.default
            
            let path  = paths[0]
            
            //  check if the folder already exists
            if fileManager.fileExists( atPath: path ) == false
            {
                _ = try? fileManager.createDirectory( atPath: path,
                                                      withIntermediateDirectories: true,
                                                      attributes: nil )
            }
            //  prepare content and write to file
            var destinationPath = "file://" + path + "/" + fileName
            destinationPath = destinationPath.replacingOccurrences(of: " ", with: "%20")
            let destinationURL = URL(string: destinationPath)
            let _ = try docData.write(to: destinationURL!, options: .atomic)
            
            var activityItems: [Any] = []
            activityItems.append(destinationURL)
            activityItems.append("HHQ Attachment")
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            
        } catch {
            print("Unable to load data: \(error)")
        }
        
        
    }
}
