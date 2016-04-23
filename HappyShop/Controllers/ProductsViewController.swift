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
    var productsCollectionView : ProductsCollectionView!
    var flowLayout : UICollectionViewFlowLayout!
    
    //Products Listing View Options
    var productListingOption : ProductListingOptions!
    
    //Token for one time dispatch...
    var token: dispatch_once_t = 0
    
    //TableView...
    var productsTableView : ProductsTableView!
    
    
    //Navigation Items...
   
    var rightButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializations()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set navigation title...
        let titleString = DataManager.sharedDataManager().selectedProductCategory as String!
        self.setNavigationTitle(titleString)
        self.navigationController?.hidesBarsOnSwipe = true
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
        //Listing views...
        self.collectionViewDefaultSettings()
        self.tableViewDefaultSettings()
        
        //CollectioView Nib...
        self.registerAllNibs()
        
        //Default listing option...
        self.productListingOption = ProductListingOptions.List
        
        //Navigation Bar
        self.leftBarButtonItem = UIBarButtonItem()
        self.rightBarButtonItem = UIBarButtonItem()
        self.navigationBarDefaultSettings()
        
    }
    
    //Do Navigation bar initial settings...
    func  navigationBarDefaultSettings() {

        self.setNavigationRightButton()
        self.navigationController?.navigationBar.translucent = false

    }
    
    //CollectionView initial settings...
    func collectionViewDefaultSettings() {
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
    func tableViewDefaultSettings() {
        
        self.productsTableView = ProductsTableView(frame: self.containerView.bounds , style: UITableViewStyle.Plain)
        self.productsTableView.backgroundColor = kCLEAR_COLOR
        self.productsTableView.productDelegate = self
        self.containerView.addSubview(self.productsTableView)
        self.productsTableView.hidden = true
        
    }

    
    
    
    //Register CollectionView Nib
    func registerAllNibs() {
        
        self.productsCollectionView.registerNib(UINib.init(nibName: "ProductsCollectionCell", bundle: nil), forCellWithReuseIdentifier:"ProductsCollectionCell")
        
    }
    //Handler when view did finish layout...
    override func didFinishLayout() {
        self.productsCollectionView.frame = self.containerView.bounds
        self.productsTableView.frame = self.containerView.bounds
    }
    
    //Right Button...
    func setNavigationRightButton() {
        if(self.navigationRightButton == nil) {
            self.navigationRightButton = UIButton(type: UIButtonType.System)
        }
        self.navigationRightButton.frame = CGRectMake(0, 0, 50, 50)
        self.navigationRightButton.imageEdgeInsets = UIEdgeInsetsMake(12,12,12,12)
        self.navigationRightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        self.navigationRightButton.tintColor = kWHITE_COLOR
        
        self.navigationRightButton.imageView?.contentMode = UIViewContentMode.Center
        self.navigationRightButton.addTarget(self, action: Selector("rightButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        self.setTopRightButton(self.navigationRightButton)
        
        //Disable user interaction untill get teh products info from server...
        self.navigationRightButton.userInteractionEnabled = false
        
    }
    
        
    //RightButtonTapped
    func rightButtonTapped() {
        self.changeProductListingView()
    }
    //MARK:- Navigation Bar Action
    //Right button action handler...
    func changeProductListingView() {
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
        
    
        let newImage =   image?.imageWithRenderingMode(.AlwaysTemplate) as UIImage!
        
        self.navigationRightButton.setImage(newImage, forState: .Normal)
        self.navigationRightButton.tintColor = kWHITE_COLOR
        
    }

    //MARK:- Change view option
    //To Grid View
    func changeViewOptionToGrid() {
        self.productsCollectionView.hidden = false
        self.productsTableView.hidden = true
        self.flowLayout.minimumInteritemSpacing = 0.5
       
        self.productsCollectionView.productsArray = self.productsTableView.productsArray
        self.productsCollectionView.reloadData()
    }
    
    //To List View
    func changeViewOptionToList() {
        self.productsCollectionView.hidden = true
        self.productsTableView.hidden = false
        self.productsTableView.productsArray = self.productsCollectionView.productsArray
        self.productsTableView.reloadData()
    }


    
    //MARK:- Fetch Products 
    func getProductsFromServer() {
        
        
        dispatch_once(&token) { () -> Void in
            
            let urlString = API_KEY+"/"+URL_FRAGMENT_API+"/"+API_VERSION+"/"+URL_DATA_PRODUCTS+URL_FRAGMENT_JSON
            let categoryString = DataManager.sharedDataManager().selectedProductCategory
            let pageNumber :Int = NUMBER_ONE
            DataManager.sharedDataManager().currentPage = NUMBER_ONE
            DataManager.sharedDataManager().isRequiredLoadNextPage = true
            let params = ["category" : categoryString, "page" : String(pageNumber)] as [String : String]
            DataManager.sharedDataManager().startActivityIndicator()
            NetworkManager.getFromServer(urlString, params: params, success: { (response : JSON) -> Void in
                
                DataManager.sharedDataManager().stopActivityIndicator()
                //populate received data on UI...
                self.populateDataOnUI(response)
                DataManager.sharedDataManager().isRequiredLoadNextPage = false
                }) { (error : NSError) -> Void in
                    DataManager.sharedDataManager().stopActivityIndicator()
                    DataManager.sharedDataManager().isRequiredLoadNextPage = false
                    self.showAlertView("Error", message: error.localizedDescription)
                    
                    
            }

            
        }
        
    }
    
    
    //MARK:- Alert local
    func showAlertView(title: String!, message : String!) {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    //MARK:- Populate Data On UI
    func populateDataOnUI(jsonData: JSON!) {
        
        //Enable right button user interaction, since response received...
        self.navigationRightButton.userInteractionEnabled = true
        
        self.productsCollectionView.backgroundColor = kGRAY_COLOR2
        self.productsCollectionView.productsArray = jsonData["products"].arrayValue 
        self.productsCollectionView.reloadData()
        self.productsTableView.productsArray = jsonData["products"].arrayValue
        self.productsTableView.reloadData()
        self.changeProductListingView()
    }

    
    //MARK:- Product Delegate
    func productSelected(product: JSON!) {
        
        self.gotoProductParticularScreen(product)
    }
    
    //MARK:- Reset Pagination Vars
    func resetPaginationVariables() {
        DataManager.sharedDataManager().currentPage = NUMBER_ONE
        DataManager.sharedDataManager().isRequiredLoadNextPage = false
    }
    
    //MARK: - Goto Product Particular Screen
    func gotoProductParticularScreen(product:JSON) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let productsVC = storyBoard.instantiateViewControllerWithIdentifier("ProductViewController") as! ProductViewController
        productsVC.particularProductJSON = product
        
        self.navigationController?.pushViewController(productsVC, animated: false)
        
    }



}
