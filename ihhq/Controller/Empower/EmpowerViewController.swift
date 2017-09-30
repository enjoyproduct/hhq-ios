//
//  EmpowerViewController.swift
//  ihhq
//
//  Created by Admin on 6/18/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class EmpowerViewController: BaseViewController {


    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setTitle(title: "EMPOWER")
        webview.loadRequest(URLRequest(url: URL(string: API.EMPOWER_URL)!))
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

