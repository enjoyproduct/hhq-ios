//
//  MenuConainerViewController.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class MenuConainerViewController: SlideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
            
            let nav = UINavigationController(rootViewController: controller)
            self.mainViewController = nav
        }
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") {
            self.leftViewController = controller
        }
//        SlideMenuOptions.hideStatusBar = true
        super.awakeFromNib()
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
