//
//  ProductViewController.swift
//  HappyShop
//
//  Created by Suresh on 4/19/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductViewController: BaseViewController {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productAvailabilityLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    //Selected Product...
    var particularProductJSON : JSON!
    
    var particularProductDetail : JSON!
    
    //Number Formatter - (comma , )separated numbers...
    let numberFormatter = NSNumberFormatter()
    

    //Navigation Items...
   
    var rightButton : UIButton!
    var rightButtonBadgeLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initializations or Allocations...
        self.initializations()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set the navigation bar title...
        let titleString  = particularProductJSON["name"].stringValue
        self.setNavigationTitle(titleString)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Get the particular product detail from server...
        self.getProductFromServer()
    }
    
    //MARK:- METHODS
    
    //MARK:- Add To Cart Tapped
    @IBAction func addToCartButtonTapped(sender: AnyObject) {
        var message : String!
        var title : String!
        if(self.particularProductDetail["product"]["under_sale"].stringValue == "true") {
            let productId = self.particularProductDetail["product"]["id"].stringValue
            
            
            if(DataManager.sharedDataManager().selectedProductList[productId] == nil)  {
                DataManager.sharedDataManager().selectedProductList[productId] = self.particularProductDetail
                
                self.updateCartBadgeLabel()
                self.saveShoppingItems()
                message = "Added to shopping bag."
                title = "Success!"
                
            }else {
                message = "This product already added to the bag."
                title = "Already available!"
                
            }
           
        }else {
            message = "Product is not availble currently."
            title = "Failed!"
        }
        self.showAlertView(title, message: message)
        
    }
    
    //Update cart badge label count...
    func updateCartBadgeLabel() {
        let cartItems = DataManager.sharedDataManager().selectedProductList
        let cartItemsCount = cartItems.count
        self.rightButtonBadgeLabel.text = String(cartItemsCount) as String!
        
    }
    
    //Save items in shopping bag...
    func saveShoppingItems() {
        if let cartItems = DataManager.sharedDataManager().selectedProductList.rawString() {
            do {
                
                print("Success : cart items" + "\(cartItems)")
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue(cartItems, forKey: kCART_ITEMS_KEY)
                defaults.synchronize()
                
            } catch let error as NSError {
                print("error in unwrapping cartitems " + error.localizedDescription)
                self.showAlertView("Something went wrong", message: "Please try again later!")
            }

        }
        
    }
    
    //MARK:- Initialization or Allocations of objects
    func initializations() {
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        self.productImageView.backgroundColor = kWHITE_COLOR
        self.productImageView.layer.masksToBounds = true
        self.productImageView.layer.cornerRadius = CGFloat(NUMBER_FIVE)
        self.productImageView.layer.borderColor = kWHITE_COLOR.CGColor
        self.productImageView.layer.borderWidth = CGFloat(NUMBER_ONE)
        self.productNameLabel.sizeToFit()
        self.productDescriptionLabel.sizeToFit()
        //Hide Add to cart button...
        self.addToCartButton.hidden = true
        
        //Avoid self.view goes underneath navigationbar
        self.navigationController?.navigationBar.translucent = false
        
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
    
    //MARK:- NavigationBar
    //Right Button...
    func setNavigationRightButton() {
        if(self.navigationRightButton == nil) {
            self.navigationRightButton = UIButton(type: UIButtonType.System)
        }
        self.navigationRightButton.frame = CGRectMake(20, 0, 50, 50)
        self.navigationRightButton.imageEdgeInsets = UIEdgeInsetsMake(12,12,12,12)
//        self.navigationRightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        let image = UIImage(named: "bag")
        let newImage = image?.imageWithRenderingMode(.AlwaysTemplate) as UIImage!
        
        self.navigationRightButton.setImage(newImage, forState: .Normal)
        self.navigationRightButton.tintColor = kBLACK_COLOR
        self.navigationRightButton.imageView?.contentMode = UIViewContentMode.Center
        self.navigationRightButton.addTarget(self, action: Selector("rightButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        
        if(self.rightButtonBadgeLabel == nil) {
            self.rightButtonBadgeLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 20, height: 20))
        }
        self.rightButtonBadgeLabel.layer.cornerRadius = 10
        self.rightButtonBadgeLabel.layer.masksToBounds = true
        self.rightButtonBadgeLabel.backgroundColor = kRED_COLOR
        self.rightButtonBadgeLabel.textColor = kWHITE_COLOR
        self.rightButtonBadgeLabel.font = UIFont(name: "HelveticaNeue", size: 10)!
        self.rightButtonBadgeLabel.minimumScaleFactor = 0.5
        self.rightButtonBadgeLabel.textAlignment = NSTextAlignment.Center
        self.updateCartBadgeLabel()
        self.navigationRightButton.addSubview(self.rightButtonBadgeLabel)
        self.setTopRightButton(self.navigationRightButton)
        
    }

    
    //Right button tapped action handler
    func rightButtonTapped() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let shoppingBagVC = storyBoard.instantiateViewControllerWithIdentifier("ShoppingBagViewController") as! ShoppingBagViewController
        
        
        self.navigationController?.pushViewController(shoppingBagVC, animated: false)
    }
    
    //MARK:- Fetch Particular Product Info
    func getProductFromServer() {
        
        let productId = self.particularProductJSON["id"].stringValue as String!
        let urlString = API_KEY+"/"+URL_FRAGMENT_API+"/"+API_VERSION+"/"+URL_DATA_PRODUCTS+"/"+productId+URL_FRAGMENT_JSON
        DataManager.sharedDataManager().startActivityIndicator()
        NetworkManager.getFromServer(urlString, params: [:], success: { (response : JSON) -> Void in
            
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

    //MARK:- Alert local
    func showAlertView(title: String!, message : String!) {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }

    func populateDataOnUI(jsonData : JSON) {
        
        self.particularProductDetail = jsonData
        
        let url  = NSURL(string:  jsonData["product"]["img_url"].stringValue)
        
        //Product Image
        self.productImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.CacheMemoryOnly)
        
        //Product Name
        self.productNameLabel.text = jsonData["product"]["name"].stringValue
        
        //Product Price
        let tempString = self.numberFormatter.stringFromNumber(NSNumber(integer:Int(jsonData["product"]["price"].doubleValue) as NSInteger!))!
        self.productPriceLabel.text =  tempString
        self.addToCartButton.hidden = false
        if(jsonData["product"]["under_sale"].stringValue == "true") {
            self.productAvailabilityLabel.text = "Available"
            self.productAvailabilityLabel.textColor = kGREEN_COLOR
//            self.addToCartButton.hidden = false
            
        }else {
            self.productAvailabilityLabel.text = "Unavailable"
            self.productAvailabilityLabel.textColor = kRED_COLOR
        }
        self.productDescriptionLabel.text = jsonData["product"]["description"].stringValue

    }

}
