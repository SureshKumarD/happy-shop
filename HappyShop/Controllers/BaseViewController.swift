//
//  BaseViewController.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // Token to dispatch once...
    var dispatchToken : dispatch_once_t = 0
    
    //Navigation Items...
    var leftBarButtonItem : UIBarButtonItem!
    var rightBarButtonItem : UIBarButtonItem!
    var navigationLeftButton : UIButton!
    var navigationRightButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initiate the Network Monitoring...
        AFNetworkReachabilityManager.sharedManager().startMonitoring();
        
        
        self.defaultStylingAndProperties()
        //Set View's gradient background color
        self.setGradientBackgroundColor(self.view);
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //Add reachability observer for the current class...
        self.addreachabilityObserver()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //Remove reachability obser for the current class...
        self.removeReachabilityObserver()

    }
    
    //MARK:- METHODS
    func defaultStylingAndProperties() {
        
        
        //Navigation - right, left barbuttonitem allocation.
        self.leftBarButtonItem = UIBarButtonItem()
        self.rightBarButtonItem = UIBarButtonItem()
    
        self.setNavigationBackButton()
        self.setNavigationBarSettings()
        
        
    }
    func setNavigationTitle(title : String!) {
        self.title = title
    }
    
    func setNavigationBarColor(color : UIColor) {
        self.navigationController?.navigationBar.barTintColor = color
    }
    
    func setNavigationBarTintColor(color : UIColor) {
        self.navigationController?.navigationBar.tintColor = color
    }
    
    //BackButton...
    func setNavigationBackButton() {
        let viewControllers = (self.navigationController?.viewControllers)! as NSArray
        
        if(viewControllers.count == NUMBER_ONE) {
            return
        }
        if(self.navigationLeftButton == nil) {
            self.navigationLeftButton = UIButton(type: UIButtonType.System)
        }
        self.navigationLeftButton.frame = CGRectMake(0, 0, 50, 50)
        self.navigationLeftButton.imageEdgeInsets = UIEdgeInsetsMake(15,12,15,12)
        self.navigationLeftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 10)
    
        let image = UIImage(named: "backArrow")
        let newImage = image?.imageWithRenderingMode(.AlwaysTemplate) as UIImage!
    
        self.navigationLeftButton.setImage(newImage, forState: .Normal)
        self.navigationLeftButton.tintColor = kBLACK_COLOR
    
    
        self.navigationLeftButton.imageView?.contentMode = UIViewContentMode.Center
        self.navigationLeftButton.addTarget(self, action: Selector("backButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        self.leftBarButtonItem.customView = self.navigationLeftButton
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem
    }

    
    //Right Button...
    func setTopRightButton(rightButton : UIButton!) {
        self.rightBarButtonItem.customView = rightButton
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem
        
    }
    
    //Back Button...
    func setTopLeftButton(leftButton : UIButton!) {
        self.leftBarButtonItem.customView = leftButton
        self.navigationItem.rightBarButtonItem = self.leftBarButtonItem
        
    }
    
    //MARK:- Navigaton Action Handlers
    //BackButtonTapped
    func backButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }


    
    //MARK:- Reachability observer - notifier
    //Add Reachability Observer
    func addreachabilityObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkChanged:"), name: AFNetworkingReachabilityDidChangeNotification, object: nil);
    }
    
    //Remove Rechability Observer
    func removeReachabilityObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AFNetworkingReachabilityDidChangeNotification, object: nil);
    }
    
    func networkChanged(sender : AnyObject) {
        let isConnected = AFNetworkReachabilityManager.sharedManager().reachable
        if(!isConnected) {
            let alertView = UIAlertView(title: "Network Unavailable!", message: "You're seems to be offline, please connect to a network", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
            
        }
    }
    
    //MARK:- Set Background Color
    func setGradientBackgroundColor(view : UIView!) {
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [kSNOW_COLOR.CGColor, kWHITE_COLOR.CGColor, kSNOW_COLOR.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    
    //MARK:- After DidLayout Actions
    override func viewDidLayoutSubviews() {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: Selector("didFinishLayout"), object: nil)
        self.performSelector(Selector("didFinishLayout"), withObject: nil, afterDelay: 0)
    }
    
    
    //When all subviews finish layout...
    func didFinishLayout() {
        
        
    }
    
    //MARK:- Set navigationbar font
    func setNavigationBarSettings() {
        dispatch_once(&dispatchToken) { () -> Void in
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 15)!, NSForegroundColorAttributeName : kBLACK_COLOR]
            
        }
        
    }



}
