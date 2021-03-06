//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Mandy Chen on 10/7/17.
//  Copyright © 2017 Mandy Chen. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    var originalLeftMargin:CGFloat!
    
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            
            menuViewController.willMove(toParentViewController: self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if(sender.state == .began){
            originalLeftMargin = leftMarginConstraint.constant
        }
        else if(sender.state == .changed){
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        }
        else if(sender.state == .ended){
            
            UIView.animate(withDuration: 0.3, animations: {
                //animate autolayout, cant change the frame within autolayout instead changing constraints
                if(velocity.x > 0){//opening menu
                    self.leftMarginConstraint.constant = self.view.frame.size.width / 2
                }
                else{//closing menu
                    self.leftMarginConstraint.constant = 0
                }
                //then call this: here self.view is the parent of the view who's constraints you are changing
                self.view.layoutIfNeeded()
            })
        }
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
