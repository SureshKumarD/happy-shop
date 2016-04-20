//
//  DataManager.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataManager: NSObject {
    //SharedInstance...
    static let dataManager = DataManager()
    
    //Activity Indicator...
    var activityIndicator : UIActivityIndicatorView?
    
    //APP Constants....
    let categoriesArray = ["Makeup", "Skincare", "Men", "Bath & Body", "Nails", "Tools"]
    
    //Variable used for pagination...
    var currentPage : Int
    var isRequiredLoadNextPage : Bool
    var selectedProductCategory :String!
    
    
    //To the cart...
    var selectedProductList : [JSON]!

    override init() {
        
//        //Initialize all data members...
//        self.isViral = true
//        self.currentAlbumCategory = AlbumGategory.Hot
        self.currentPage = 0
        self.isRequiredLoadNextPage = false
        
    }
    
    
    
    class func sharedDataManager()-> DataManager! {
        return dataManager
    }
    
    
    //MARK: - Acitivity Indicator - usage
    func startActivityIndicator() {
        
        if(self.activityIndicator == nil){
            self.activityIndicator  = UIActivityIndicatorView()
            
        }
        self.activityIndicator?.frame = CGRectMake(WIDTH_WINDOW_FRAME/2 - 50, HEIGHT_WINDOW_FRAME/2-50, 100, 100)
        self.activityIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        let mainWindow = UIApplication.sharedApplication().keyWindow
        mainWindow?.addSubview(self.activityIndicator!)
        
        self.activityIndicator?.startAnimating()
    }
    
    
    func stopActivityIndicator() {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
    }

    func loadLastAddedProductList() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let items = defaults.valueForKey("kCART_ITEMS")
        //        let data = NSJSONSerialization.dataWithJSONObject(array, options: nil, error: nil)
//        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
//        self.selectedProductList = JSON(
    }

}
