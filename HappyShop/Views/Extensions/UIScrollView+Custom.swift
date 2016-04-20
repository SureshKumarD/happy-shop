//
//  UIScrollView+Custom.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON


extension UIScrollView : UIScrollViewDelegate {
    
    
    
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //If scrollview is not CategoriesCollectionView quit abruptly...
        let isProductsCollectionView = (self.isKindOfClass(ProductsCollectionView)) as Bool
        let isProductsTableView = (self.isKindOfClass(ProductsTableView)) as Bool
        if(!((isProductsCollectionView == true ) || ( isProductsTableView == true))) {
            return;
        }
        
        
        if(self.contentOffset.y >= self.contentSize.height - self.bounds.size.height) {
        if(DataManager.sharedDataManager().isRequiredLoadNextPage == false ) {
        DataManager.sharedDataManager().isRequiredLoadNextPage = true
        DataManager.sharedDataManager().currentPage += 1
        print("pageNumber : \(DataManager.sharedDataManager().currentPage)")
        DataManager.sharedDataManager().startActivityIndicator()
        self.fetchProducts()
        }
        }
    }
    
    func fetchProducts() {
        let sharedInstance = DataManager.sharedDataManager()
        let urlString = API_KEY+"/"+URL_FRAGMENT_API+"/"+API_VERSION+"/"+URL_DATA_PRODUCTS
        let categoryString = DataManager.sharedDataManager().selectedProductCategory
        let pageNumber = DataManager.sharedDataManager().currentPage
        let params = ["category" : categoryString, "page" : String(pageNumber)] as [String : String]
        NetworkManager.getFromServer(urlString, params: params, success: { (response : JSON) -> Void in
            
            
            if(response["products"].count > NUMBER_ZERO) {
                
                self.reloadTableOrCollectionView(response["products"].arrayObject! as [AnyObject])
                sharedInstance.isRequiredLoadNextPage = false
                DataManager.sharedDataManager().stopActivityIndicator()
            }

            }) { (error : NSError) -> Void in
                //Failed to fetch...
        }
        
    }
    
    
    func reloadTableOrCollectionView(objects: [AnyObject]!) {
        //Does nothing...
        //This Super class implementaion can be replaced with SubClass call.
    }

    
}