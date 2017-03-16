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
    
    
    @IBOutlet weak var containerView: UIView!
    
    //CollectionView...
    private var productsCollectionView : ProductsCollectionView!
    private var flowLayout : UICollectionViewFlowLayout!
    
    //Products Listing View Options
    private var productListingOption : ProductListingOptions!
    
    //Token for one time dispatch...
//    private var token: dispatch_once_t = 0
    
    //TableView...
    private var productsTableView : ProductsTableView!
    
    
    //Navigation Items...
    private var rightButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializations()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set navigation title...
        let titleString = DataManager.sharedDataManager.selectedProductCategory as String!
        self.setNavigationTitle(title: titleString)
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getProductsFromServer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resetPaginationVariables()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- METHODS
    
    
    private func initializations() {
        //Listing views...
        self.collectionViewDefaultSettings()
        self.tableViewDefaultSettings()
        
        //CollectioView Nib...
        self.registerAllNibs()
        
        //Default listing option...
        self.productListingOption = ProductListingOptions.List
        
        self.navigationBarDefaultSettings()
        
    }
    
    //Do Navigation bar initial settings...
    private func navigationBarDefaultSettings() {

        self.setNavigationRightButton()
        self.navigationController?.navigationBar.isTranslucent = false

    }
    
    //CollectionView initial settings...
    private func collectionViewDefaultSettings() {
        //CollectionView...
        self.flowLayout  = UICollectionViewFlowLayout()
        self.flowLayout.minimumInteritemSpacing = 0.5
        self.flowLayout.minimumLineSpacing = 1
        
        self.productsCollectionView = ProductsCollectionView(frame: self.containerView.bounds , collectionViewLayout: flowLayout)
        self.productsCollectionView.backgroundColor = kCLEAR_COLOR
        self.productsCollectionView.productDelegate = self
        self.containerView.addSubview(self.productsCollectionView)
        
    }
    
    // TableView initial settings...
    private func tableViewDefaultSettings() {
        
        self.productsTableView = ProductsTableView(frame: self.containerView.bounds , style: UITableViewStyle.plain)
        self.productsTableView.backgroundColor = kCLEAR_COLOR
        self.productsTableView.productDelegate = self
        self.containerView.addSubview(self.productsTableView)
        self.productsTableView.isHidden = true
        
    }
    
    //Register CollectionView Nib
    private func registerAllNibs() {
        
        self.productsCollectionView.register(UINib.init(nibName: "ProductsCollectionCell", bundle: nil), forCellWithReuseIdentifier:"ProductsCollectionCell")
        
    }
    
    //Handler when view did finish layout...
    override func didFinishLayout() {
        self.productsCollectionView.frame = self.containerView.bounds
        self.productsTableView.frame = self.containerView.bounds
    }
    
    //Right Button...
    private func setNavigationRightButton() {
        if(self.rightButton == nil) {
            self.rightButton = UIButton(type: UIButtonType.system)
        }
        self.rightButton.frame =  CGRect(x:0, y:0, width:50, height:50)
        self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(12,12,12,12)
        self.rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        self.rightButton.tintColor = kWHITE_COLOR
        
        self.rightButton.imageView?.contentMode = UIViewContentMode.center
        self.rightButton.addTarget(self, action: #selector(ProductsViewController.rightButtonTapped), for: UIControlEvents.touchUpInside)
        self.setTopRightButton(rightButton: self.rightButton)
        
        //Disable user interaction untill get teh products info from server...
        self.rightButton.isUserInteractionEnabled = false
        
    }
    
        
    //RightButtonTapped
    func rightButtonTapped() {
        self.changeProductListingView()
    }
    
    
    //MARK:- Navigation Bar Action
    //Right button action handler...
    private func changeProductListingView() {
        var image :UIImage!
        switch(self.productListingOption) {
            
        case ProductListingOptions.Grid? :
            self.productListingOption = ProductListingOptions.List
            image = UIImage(named: "listIcon")
            self.changeViewOptionToList()
            break
            
        case ProductListingOptions.List?:
            self.productListingOption = ProductListingOptions.Grid
            image = UIImage(named: "gridIcon2")
            self.changeViewOptionToGrid()
            break
            
            
        default:
            break
        }
        
    
        let newImage =   image?.withRenderingMode(.alwaysTemplate) as UIImage!
        
        self.rightButton.setImage(newImage, for: .normal)
        self.rightButton.tintColor = kWHITE_COLOR
        
    }

    //MARK:- Change view option
    //To Grid View
    private func changeViewOptionToGrid() {
        self.productsCollectionView.isHidden = false
        self.productsTableView.isHidden = true
        self.flowLayout.minimumInteritemSpacing = 0.5
       
        self.productsCollectionView.productsArray = self.productsTableView.productsArray
        self.productsCollectionView.reloadData()
    }
    
    //To List View
    private func changeViewOptionToList() {
        self.productsCollectionView.isHidden = true
        self.productsTableView.isHidden = false
        self.productsTableView.productsArray = self.productsCollectionView.productsArray
        self.productsTableView.reloadData()
    }


    
    //MARK:- Fetch Products 
    private func getProductsFromServer() {
        
        
//        dispatch_once(&token) { () -> Void in
        
            let urlString = API_KEY+"/"+URL_FRAGMENT_API+"/"+API_VERSION+"/"+URL_DATA_PRODUCTS+URL_FRAGMENT_JSON
            let categoryString = DataManager.sharedDataManager.selectedProductCategory
            let pageNumber :Int = NUMBER_ONE
            DataManager.sharedDataManager.currentPage = NUMBER_ONE
            DataManager.sharedDataManager.isRequiredLoadNextPage = true
            let params = ["category" : categoryString!, "page" : String(pageNumber)] as [String : String]
            DataManager.sharedDataManager.startActivityIndicator()
            NetworkManager.getFromServer(urlString: urlString, params: params, success: { (response : AnyObject?) -> Void in
                 DataManager.sharedDataManager.stopActivityIndicator()
                if let productList = response as? [[String:AnyObject]] {
                    var productsArray : [Product] = [];
                    for eachProduct in productList {
                        let product = Product()
                        if let productName = eachProduct["name"] as? String? {
                            product.productName = productName;
                        }
                        if let productImageUrl = eachProduct["img_url"] as? String? {
                            product.productImageUrl = productImageUrl;
                        }
                        
                        if let productId = eachProduct["id"] as? Int64? {
                            product.productId = productId;
                        }
                        
                        if let productPrice = eachProduct["price"] as? Double? {
                            product.productPrice = productPrice;
                        }
                        
                        if let productAvailability = eachProduct["under_sale"] as? Bool {
                            product.productAvailability = productAvailability;
                        }
                        
                        if let productCategory = eachProduct["category"] as? String? {
                            product.productCategory = productCategory;
                        }

                        productsArray.append(product);
                        
                    }
                }
               
                //populate received data on UI...
                self.populateDataOnUI(jsonData: response)
                DataManager.sharedDataManager.isRequiredLoadNextPage = false
                }) { (error : NSError) -> Void in
                    DataManager.sharedDataManager.stopActivityIndicator()
                    DataManager.sharedDataManager.isRequiredLoadNextPage = false
                    self.showAlertView(title: "Error", message: error.localizedDescription)
                    
                    
//            }

            
        }
        
    }
    
    
    //MARK:- Alert local
    private func showAlertView(title: String!, message : String!) {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    //MARK:- Populate Data On UI
    private func populateDataOnUI(productsArray: [[String : AnyObject]]!) {
        
        //Enable right button user interaction, since response received...
        self.rightButton.isUserInteractionEnabled = true
        
        self.productsCollectionView.backgroundColor = kGRAY_COLOR2
//        self.productsCollectionView.productsArray = jsonData["products"].arrayValue 
        self.productsCollectionView.reloadData()
        self.productsTableView.productsArray = jsonData["products"].arrayValue
        self.productsTableView.reloadData()
        self.changeProductListingView()
    }

    
    //MARK:- Product Delegate
    func productSelected(product: JSON!) {
        
        self.gotoProductParticularScreen(product: product)
    }
    
    //MARK:- Reset Pagination Vars
    private func resetPaginationVariables() {
        DataManager.sharedDataManager.currentPage = NUMBER_ONE
        DataManager.sharedDataManager.isRequiredLoadNextPage = false
    }
    
    //MARK: - Goto Product Particular Screen
    private func gotoProductParticularScreen(product:JSON) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let productsVC = storyBoard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        productsVC.particularProductJSON = product
        
        self.navigationController?.pushViewController(productsVC, animated: false)
        
    }



}
