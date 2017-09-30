//
//  HomeContainerViewController.swift
//  ihhq
//
//  Created by Admin on 6/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CarbonKit

class HomeContainerViewController: UIViewController, CarbonTabSwipeNavigationDelegate {

    let titles = ["Documents", "Updates", "Payments", "Contacts", "Correspondence"]
    var carbonTabSwiftNavigation: CarbonTabSwipeNavigation? = nil
    var fileModel: FileModel? = nil
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.fileModel != nil {
            self.setTitle(title: (self.fileModel?.project_name)! + " \n File Ref: " + (self.fileModel?.file_ref)!)
        }
        
        carbonTabSwiftNavigation = CarbonTabSwipeNavigation(items: titles, delegate: self)
        carbonTabSwiftNavigation?.insert(intoRootViewController: self)
        
        self.style()
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
        
        carbonTabSwiftNavigation?.carbonSegmentedControl?.setWidth(getScreenSize().width / 5.7 * 1.2, forSegmentAt: 0)
        carbonTabSwiftNavigation?.carbonSegmentedControl?.setWidth(getScreenSize().width / 5.7 * 0.9, forSegmentAt: 1)
        carbonTabSwiftNavigation?.carbonSegmentedControl?.setWidth(getScreenSize().width / 5.7 * 1.0, forSegmentAt: 2)
        carbonTabSwiftNavigation?.carbonSegmentedControl?.setWidth(getScreenSize().width / 5.7 * 0.9, forSegmentAt: 3)
        carbonTabSwiftNavigation?.carbonSegmentedControl?.setWidth(getScreenSize().width / 5.7 * 1.6, forSegmentAt: 4)
        
        //customize segment color
        let font = robotoMedium(size: 11)
        carbonTabSwiftNavigation?.setNormalColor(Constant.lightGray.withAlphaComponent(0.6), font: font)
        carbonTabSwiftNavigation?.setSelectedColor(UIColor.white, font: font)
    }

    // MARK: - CarbonTabSwipeNavigationDelegate
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeDocumentViewController") as! HomeDocumentViewController
            vc.fileModel = self.fileModel
            return vc
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeUpdateViewController") as! HomeUpdateViewController
            vc.fileModel = self.fileModel
            return vc
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePaymentViewController") as! HomePaymentViewController
            vc.fileModel = self.fileModel
            return vc
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeContactViewController") as! HomeContactViewController
            vc.fileModel = self.fileModel
            return vc
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeSupportViewController") as! HomeSupportViewController
            vc.fileModel = self.fileModel
            return vc
        default:
            return UIViewController()
        }
        
        
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willMoveAt index: UInt) {
        
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        if index == 4 { //correspondence
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newSupportRequest))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    func barPosition(for carbonTabSwipeNavigation: CarbonTabSwipeNavigation) -> UIBarPosition {
        return UIBarPosition.top; // default UIBarPositionTop
    }
    
    func newSupportRequest(sender: UIBarButtonItem) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewSupportRequestViewController") as! NewSupportRequestViewController
        vc.selectedFileRef = (self.fileModel?.file_ref)!
        vc.selectedDepartmentID = (self.fileModel?.category_id)!
        self.navigationController?.pushViewController(vc, animated: true)
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
