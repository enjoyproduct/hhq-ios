//
//  BaseViewController.swift
//  ihhq
//
//  Created by Admin on 6/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = Constant.colorPrimary
        self.navigationController?.navigationBar.barTintColor = Constant.toolbarColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constant.colorPrimary]

        self.addRightBarButtonWithImage(UIImage(named: "dot3_yellow")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let backItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem

    }
    
    func initTitleLabel(title: String) {
        let label = UILabel(frame: CGRect(x:0, y:0, width:getScreenSize().width, height:50))
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 2
        label.font = robotoMedium(size: 17)
        label.textAlignment = .center
        label.textColor = Constant.colorPrimary
        label.text = title
        self.navigationItem.titleView = label
    }
    
    func setTitle(title: String) {
        self.initTitleLabel(title: title)
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
