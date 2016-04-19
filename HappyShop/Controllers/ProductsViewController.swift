//
//  ProductsViewController.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import SwiftyJSON


class ProductsViewController: BaseViewController,ProductDelegate {
    //CollectionView...
    var productsCollectionView : ProductsCollectionView!
    var flowLayout : UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = DataManager.sharedDataManager().selectedProductCategory 
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.getProductsFromServer()
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.resetPaginationVariables()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- METHODS
    
    
    func initializations() {
        self.collectionViewDefaultSettings()
        self.registerAllNibs()
        
    }
    //CollectionView initial settings...
    func collectionViewDefaultSettings() {
        //CollectionView...
        self.flowLayout  = UICollectionViewFlowLayout()
        self.flowLayout.minimumInteritemSpacing = 2.5
        self.flowLayout.minimumLineSpacing = 5
        
        self.productsCollectionView = ProductsCollectionView(frame: self.view.bounds , collectionViewLayout: flowLayout)
        self.productsCollectionView.backgroundColor = kCLEAR_COLOR
        self.productsCollectionView.productDelegate = self
        self.view.addSubview(self.productsCollectionView)
        
    }
    
    //Register CollectionView Nib
    func registerAllNibs() {
        
        self.productsCollectionView.registerNib(UINib.init(nibName: "ProductsCollectionCell", bundle: nil), forCellWithReuseIdentifier:"ProductsCollectionCell")
        
    }
    
    //MARK:- Fetch Products 
    func getProductsFromServer() {
        let urlString = API_KEY+"/"+URL_FRAGMENT_API+"/"+API_VERSION+"/"+URL_DATA_PRODUCTS
        let categoryString = DataManager.sharedDataManager().selectedProductCategory
        let pageNumber = DataManager.sharedDataManager().currentPage = NUMBER_ONE
        let params = ["category" : categoryString, "page" : String(pageNumber)] as [String : String]
        DataManager.sharedDataManager().startActivityIndicator()
        NetworkManager.getFromServer(urlString, params: params, success: { (response : JSON) -> Void in
            
            DataManager.sharedDataManager().stopActivityIndicator()
            //populate received data on UI...
            self.populateDataOnUI(response)
        
            }) { (error : NSError) -> Void in
                DataManager.sharedDataManager().stopActivityIndicator()
                self.showAlertView("Error", message: error.localizedDescription)
               
        }
    }
    
    //MARK:- Alert local
    func showAlertView(title: String!, message : String!) {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    //MARK:- Populate Data On UI
    func populateDataOnUI(jsonData: JSON!) {
        self.productsCollectionView.productsArray = jsonData["products"].arrayValue 
        self.productsCollectionView.reloadData()
        
    }

    
    //MARK:- Product Delegate
    func productSelected(product: JSON!) {
        
        
    }
    
    //MARK:- Reset Pagination Vars
    func resetPaginationVariables() {
        DataManager.sharedDataManager().currentPage = NUMBER_ONE
        DataManager.sharedDataManager().isRequiredLoadNextPage = false
    }
    
    


}
