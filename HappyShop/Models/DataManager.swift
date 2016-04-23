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
    
    //MARK:- Shared Instance
    class func sharedDataManager()-> DataManager! {
        //Returns the static, singleton instance...
        return dataManager
    }

    //MARK:- Init
    override init() {
        
        self.currentPage = 0
        self.isRequiredLoadNextPage = false
        
        //Get the available saved items from the DB.
        //Returns a tuple(multiple objects i.,e valueString, managedObject).
        //It's required to valueString only, so, unwrap and store it in singleton object.
        let jsonString = KeyValueDataBaseManager.objectStringForKey(kCART_ITEMS_KEY)
        if((jsonString.valueString?.isEmpty) == false) {
            let jsonObject = DataManager.convertStringToJSON(jsonString.valueString!)! as JSON
            self.selectedProductList = jsonObject
        }
        super.init()
        
    }
    
    //MARK:- METHODS
    
    //Convert the string into JSON object...
    class func convertStringToJSON(jsonString: String) -> JSON? {
        if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            return json
        }
        return nil
    }
    
    
    //MARK:- Gradient BackGround Color
    func setGradientBackgroundColor(view : UIView!) {
        
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [kSNOW_COLOR.CGColor, kWHITE_COLOR.CGColor, kSNOW_COLOR.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        
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
