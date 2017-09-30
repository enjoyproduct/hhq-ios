//
//  BlogViewController.swift
//  ihhq
//
//  Created by Admin on 6/15/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class BlogViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnLogin: UIButton!
    
    let swipeGestureLeft = UISwipeGestureRecognizer()
    let swipeGestureRight = UISwipeGestureRecognizer()
    
    let enImageName = ["blog1", "blog2", "blog3", "blog4"]
    let enTexts = ["Legal access redefined.",
                   "Your Privacy, Our Priority.",
                   "Empowering everybody with Law.",
                   "Precedents as a starting point."]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden  = true
        btnLogin.makeRoundCorner(cornerRadius: 4)
        // set gesture direction
        self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.left
        self.swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right
        
        // add gesture target
        self.swipeGestureLeft.addTarget(self, action: #selector(self.handleSwipeLeft(_:)))
        self.swipeGestureRight.addTarget(self, action: #selector(self.handleSwipeRight(_:)))
        
        // add gesture in to view
        self.view.addGestureRecognizer(self.swipeGestureLeft)
        self.view.addGestureRecognizer(self.swipeGestureRight)
        
        self.pageControl.numberOfPages = enImageName.count
        // set current page number label.
        self.setCurrentPageLabel()
        self.setupPageControl()
    }
    fileprivate func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.white
        appearance.currentPageIndicatorTintColor = UIColor.gray
        appearance.backgroundColor = UIColor.clear
    }
    // MARK: - Utility function
    
    // increase page number on swift left
    func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer){
        if self.pageControl.currentPage < 5 {
            self.pageControl.currentPage += 1
            
        } else {
            self.pageControl.currentPage = 0
        }
        self.setCurrentPageLabel()
        self.animate(1)
    }
    
    // reduce page number on swift right
    func handleSwipeRight(_ gesture: UISwipeGestureRecognizer){
        
        if self.pageControl.currentPage != 0 {
            self.pageControl.currentPage -= 1
            
        } else {
            self.pageControl.currentPage = 5
        }
        self.setCurrentPageLabel()
        self.animate(0)
    }
    
    // set current page number label
    func setCurrentPageLabel(){
        self.imageView.image = UIImage(named: enImageName[self.pageControl.currentPage])
        self.textView.text = self.enTexts[self.pageControl.currentPage]
        //        self.currentPageLabel.text = "\(self.myPageControl.currentPage + 1)"
        
        
    }
    func animate(_ direction: Int)  {
        let transition = CATransition()
        transition.duration = 1.0
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        if direction == 0 { //right to left
            transition.type = kCATransitionFromRight
        } else { //left to right
            transition.type = kCATransitionFromLeft
        }
        
        self.imageView.layer.add(transition, forKey: nil)
    }
    @IBAction func onCreateAccount(_ sender: Any) {
        UIApplication.shared.open(URL(string: API.REGISTER)!, options: [:], completionHandler: nil)
    }
    @IBAction func onTermsAndCondition(_ sender: Any) {
        UIApplication.shared.open(URL(string: API.TERMS_AND_POLICY)!, options: [:], completionHandler: nil)
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
