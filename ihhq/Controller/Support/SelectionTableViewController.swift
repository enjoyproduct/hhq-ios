//
//  SelectionTableViewController.swift
//  ihhq
//
//  Created by Admin on 7/4/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol SelectionTableViewControllerDelegate {
    func selected(index: Int, type: Int)
    func returnSelectedFileURL(url: String)
}
class SelectionTableViewController: UITableViewController, UIDocumentPickerDelegate, UIDocumentMenuDelegate, UINavigationControllerDelegate {

    var arrContents: [String]? = nil
    var type = 0 // 0:department, 1:file ref, 2: attachment
    var delegate: SelectionTableViewControllerDelegate? = nil
    var fileName = ""
    var fileURL: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        if self.type == 2 {
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addAttachment))
        }
        
    }
    
    func addAttachment(sender:UIBarButtonItem) {
        let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypePDF as String, kUTTypeContent as String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
        
//        let documentPicker = UIDocumentPickerViewController(documentTypes: ["xlsx", "pdf", "doc"], in: .import)
//        documentPicker.delegate = self
//        present(documentPicker, animated: true, completion: nil)
        
    }

    @available(iOS 8.0, *)
    // MARK:- UIDocumentMenuDelegate
    public func documentMenu(_ documentMenu:  UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    // MARK:- UIDocumentPickerDelegate
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        print("The Url is : /(url)")
        fileURL = url as URL
        fileName = (fileURL?.lastPathComponent)!
        if self.delegate != nil {
            self.delegate?.returnSelectedFileURL(url: url.absoluteString)
            
        }
        self.navigationController?.popViewController(animated: true)
        //optional, case PDF -> render
        //displayPDFweb.loadRequest(NSURLRequest(url: cico) as URLRequest)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        print("we cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.arrContents?.count) ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = self.arrContents?[indexPath.row].components(separatedBy: "/").last

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil {
            if self.type == 2 {
                
            } else {
                delegate?.selected(index: indexPath.row, type: self.type)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         //Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
