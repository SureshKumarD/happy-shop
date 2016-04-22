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
    var selectedProductList : JSON = [:]

    override init() {
        
        self.currentPage = 0
        self.isRequiredLoadNextPage = false
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let jsonString = defaults.valueForKey(kCART_ITEMS_KEY) as? String
        if((jsonString?.isEmpty) == false) {
            let jsonObject = DataManager.convertStringToDictionary(jsonString!)! as JSON
            self.selectedProductList = jsonObject
        }
        super.init()
        
    }
    
    
    class func convertStringToDictionary(jsonString: String) -> JSON? {
        if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            return json
        }
        return nil
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

   
}
