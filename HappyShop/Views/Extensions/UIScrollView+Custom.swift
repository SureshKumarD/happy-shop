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
    
    //Subclasses tableView & collectionView both uses this extension.
    //This extension is specially created to implement pagination on product list...
    //On the scrollViews' (tableView or collectionView) did scroll delegate event,
    //Check for the content offset, if we reached the bottom of the scrollView,
    //Call the server with the currentpage + 1 with a callback closure.
    //On return of the callback, just populate the results fetched into the 
    //subclasses' (tableView or collectionView) overriden method 'reloadTableOrCollectionView'.
    //In the respective subclasses 'reloadTableOrCollectionView' this overriden method,
    //Just appends the fetched results and populates on the UI.
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //If scrollview is not ProductsCollectionView or ProductsTableView quit abruptly...
        let isProductsCollectionView = (self.isKindOfClass(ProductsCollectionView)) as Bool
        let isProductsTableView = (self.isKindOfClass(ProductsTableView)) as Bool
        if(!((isProductsCollectionView == true ) || ( isProductsTableView == true))) {
            return;
        }
        
        //If the contentOffset is reached at the bottom the scrollView,
        //Do the required pagination actions...
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
    
    
    //Server call to fetch the next page from the current page...
    func fetchProducts() {
        let sharedInstance = DataManager.sharedDataManager()
        let urlString = API_KEY+"/"+URL_FRAGMENT_API+"/"+API_VERSION+"/"+URL_DATA_PRODUCTS
        let categoryString = DataManager.sharedDataManager().selectedProductCategory
        let pageNumber = DataManager.sharedDataManager().currentPage
        let params = ["category" : categoryString, "page" : String(pageNumber)] as [String : String]
        NetworkManager.getFromServer(urlString, params: params, success: { (response : JSON) -> Void in
            
            
            if(response["products"].count > NUMBER_ZERO) {
                //On successful response, call the particular subclass's overriden reload method.
                self.reloadTableOrCollectionView(response["products"].arrayObject! as [AnyObject])
                sharedInstance.isRequiredLoadNextPage = false
                DataManager.sharedDataManager().stopActivityIndicator()
            }

            }) { (error : NSError) -> Void in
                //Failed to fetch...
                print("Pagination error "+error.localizedDescription)
                DataManager.sharedDataManager().stopActivityIndicator()
        }
        
    }
    
    
    func reloadTableOrCollectionView(objects: [AnyObject]!) {
        //Does nothing...
        //This Super class implementaion can be replaced with SubClass call.
    }

    
}