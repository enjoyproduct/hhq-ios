//
//  SupportContainerViewController.swift
//  ihhq
//
//  Created by Admin on 6/18/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CarbonKit

class SupportContainerViewController: BaseViewController,CarbonTabSwipeNavigationDelegate {

    var titles = [String]()
    var carbonTabSwiftNavigation: CarbonTabSwipeNavigation? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setTitle(title: "CORRESPONDENCE")
        //add left plus button
        if Global.me.role == Constant.arrUserRoles[0] {//show close tab only for admin
            titles = ["Active", "Unassigned", "Completed"]
        } else {
            titles = ["Active", "Unassigned"]
        }
        if Global.me.role != Constant.arrUserRoles[6] {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newSupportRequest))
            
        }
        //
        carbonTabSwiftNavigation = CarbonTabSwipeNavigation(items: titles, delegate: self)
        carbonTabSwiftNavigation?.insert(intoRootViewController: self)
        
        self.style()
    }
    func style()  {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = Constant.colorPrimary
        self.navigationController?.navigationBar.barTintColor = Constant.toolbarColor
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        
        carbonTabSwiftNavigation?.toolbar.isTranslucent = true
        carbonTabSwiftNavigation?.toolbar.backgroundColor = Constant.toolbarColor
        carbonTabSwiftNavigation?.toolbar.barTintColor = Constant.toolbarColor
        carbonTabSwiftNavigation?.toolbar.tintColor = Constant.colorPrimary
        carbonTabSwiftNavigation?.setIndicatorColor(Constant.colorPrimary)
        
        //        carbonTabSwiftNavigation?.setTabExtraWidth(30)
        if Global.me.role == Constant.arrUserRoles[0] {
            carbonTabSwiftNavigation?.carbonSegmentedControl?.setWidth(getScreenSize().width / 3, forSegmentAt: 0)
            carbonTabSwiftNavigation?.carbonSegmentedControl?.setWidth(getScreenSize().width / 3, forSegmentAt: 1)
            carbonTabSwiftNavigation?.carbonSegmentedControl?.setWidth(getScreenSize().width / 3, forSegmentAt: 2)
        } else {
            carbonTabSwiftNavigation?.carbonSegmentedControl?.setWidth(getScreenSize().width / 2, forSegmentAt: 0)
            carbonTabSwiftNavigation?.carbonSegmentedControl?.setWidth(getScreenSize().width / 2, forSegmentAt: 1)
            
        }
        
        //customize segment color
        let font = robotoMedium(size: 12)
        carbonTabSwiftNavigation?.setNormalColor(Constant.lightGray.withAlphaComponent(0.6), font: font)
        carbonTabSwiftNavigation?.setSelectedColor(UIColor.white, font: font)
    }
    
    func newSupportRequest(sender: UIBarButtonItem) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewSupportRequestViewController") as! NewSupportRequestViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - CarbonTabSwipeNavigationDelegate
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupportBaseViewController") as! SupportBaseViewController
            vc.type = 1
            return vc
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupportBaseViewController") as! SupportBaseViewController
            vc.type = 0
            return vc
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupportBaseViewController") as! SupportBaseViewController
            vc.type = 2
            return vc
        default:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupportBaseViewController") as! SupportBaseViewController
            vc.type = 1
            return vc
        }

    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willMoveAt index: UInt) {
        
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
    }
    func barPosition(for carbonTabSwipeNavigation: CarbonTabSwipeNavigation) -> UIBarPosition {
        return UIBarPosition.top; // default UIBarPositionTop
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
