//
//  DocumentViewController.swift
//  ihhq
//
//  Created by Admin on 7/27/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.url != nil {
            webView.loadRequest(URLRequest(url: url!))
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
