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
    
    private var particularProductDetail : JSON!
    
    //Number Formatter - (comma , )separated numbers...
    private let numberFormatter = NumberFormatter()
    
    // Token to dispatch once...
//    private var dispatchToken2 : dispatch_once_t = 0

    //Navigation Items...
   
    private var rightButton : UIButton!
    private var rightButtonBadgeLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initializations or Allocations...
        self.initializations()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set the navigation bar title...
        let titleString  = particularProductJSON["name"].stringValue
        self.setNavigationTitle(title: titleString)
        
        //Update the bag item count...
        self.updateCartBadgeLabel()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Get the particular product detail from server...
        self.getProductFromServer()
    }
    
    //MARK:- METHODS
    
    //MARK:- Add To Cart Tapped
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        var message : String!
        var title : String!
        if(self.particularProductDetail["product"]["under_sale"].stringValue == "true") {
            let productId = self.particularProductDetail["product"]["id"].stringValue
            
            
            if(DataManager.sharedDataManager.selectedProductList[productId] == nil)  {
                DataManager.sharedDataManager.selectedProductList[productId] = self.particularProductDetail
                
                self.updateCartBadgeLabel()
                self.saveShoppingItems()
                message = "Product added to shopping bag."
                title = "Product Added!"
                
            }else {
                message = "This product already added to your shopping bag."
                title = "Already added!"
                
            }
            
        }else {
            message = "Product is not availble currently."
            title = "Unavailable!"
        }
        self.showAlertView(title: title, message: message)
    }
    
    
    //Update cart badge label count...
    private func updateCartBadgeLabel() {
        let cartItems = DataManager.sharedDataManager.selectedProductList
        let cartItemsCount = cartItems.count
        self.rightButtonBadgeLabel.text = String(cartItemsCount) as String!
        
    }
    
    //Save items in shopping bag...
    private func saveShoppingItems() {
        //Deliberately converting all the data in hand to string(json object string),
        //To make the Coredata updation simple and faster.
        //And the converted string will be replaced with the old string based on
        //the key kCART_ITEMS_KEY.
        if let cartItems = DataManager.sharedDataManager.selectedProductList.rawString() {
            KeyValueDataBaseManager.saveObject(key: kCART_ITEMS_KEY, objectString: cartItems)
        }
        
    }
    
    //MARK:- Initialization or Allocations of objects
    private func initializations() {
        self.numberFormatter.numberStyle = NumberFormatter.Style.currency
        self.productImageView.backgroundColor = kWHITE_COLOR
        self.productImageView.layer.masksToBounds = true
        self.productImageView.layer.cornerRadius = CGFloat(NUMBER_FIVE)
        self.productImageView.layer.borderColor = kWHITE_COLOR.cgColor
        self.productImageView.layer.borderWidth = CGFloat(NUMBER_ONE)
        self.productNameLabel.sizeToFit()
        self.productDescriptionLabel.sizeToFit()
        //Hide Add to cart button...
        self.addToCartButton.isHidden = true
    
        //Navigation Bar
        self.navigationBarDefaultSettings()
        
    }
    
    //Do Navigation bar initial settings...
    private func navigationBarDefaultSettings() {
        
        self.setNavigationRightButton()
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    
    //MARK:- NavigationBar
    //Right Button...
    private func setNavigationRightButton() {
        if(self.rightButton == nil) {
            self.rightButton = UIButton(type: UIButtonType.system)
        }
        self.rightButton.frame = CGRect(x: 20, y: 0, width: 50, height: 50)
        self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(12,12,12,12)
        let image = UIImage(named: "icon_shop")
        let newImage = image?.withRenderingMode(.alwaysTemplate) as UIImage!
        self.rightButton.setImage(newImage, for: .normal)
        self.rightButton.tintColor = kWHITE_COLOR
        self.rightButton.imageView?.contentMode = UIViewContentMode.center
        self.rightButton.addTarget(self, action: #selector(ProductViewController.rightButtonTapped), for: UIControlEvents.touchUpInside)
        
        if(self.rightButtonBadgeLabel == nil) {
            self.rightButtonBadgeLabel = UILabel(frame: CGRect(x: 30, y: 25, width: 20, height: 20))
        }
        self.rightButtonBadgeLabel.layer.cornerRadius = 10
        self.rightButtonBadgeLabel.layer.masksToBounds = true
        self.rightButtonBadgeLabel.backgroundColor = kRED_COLOR
        self.rightButtonBadgeLabel.textColor = kWHITE_COLOR
        self.rightButtonBadgeLabel.font = UIFont(name: "HelveticaNeue", size: 10)!
        self.rightButtonBadgeLabel.minimumScaleFactor = 0.5
        self.rightButtonBadgeLabel.textAlignment = NSTextAlignment.center
        self.rightButton.addSubview(self.rightButtonBadgeLabel)
        self.setTopRightButton(rightButton: self.rightButton)
        
    }

    
    //Right button tapped action handler
    func rightButtonTapped() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let shoppingBagVC = storyBoard.instantiateViewController(withIdentifier: "ShoppingBagViewController") as! ShoppingBagViewController
        
        
        self.navigationController?.pushViewController(shoppingBagVC, animated: false)
    }
    
    //MARK:- Fetch Particular Product Info
    func getProductFromServer() {
        //TODO:- Get particular product once for this instance.
        let productId = particularProductJSON["id"].stringValue as String!
        let urlString = "\(API_KEY)/\(URL_FRAGMENT_API)/\(API_VERSION)/\(URL_DATA_PRODUCTS)/"+"\(productId!)"+"\(URL_FRAGMENT_JSON)"
        DataManager.sharedDataManager.startActivityIndicator()
        NetworkManager.getFromServer(urlString: urlString, params: [:], success: { (response : JSON) -> Void in
            
            DataManager.sharedDataManager.stopActivityIndicator()
            //populate received data on UI...
            self.populateDataOnUI(jsonData: response)
            DataManager.sharedDataManager.isRequiredLoadNextPage = false
        }) { (error : NSError) -> Void in
            DataManager.sharedDataManager.stopActivityIndicator()
            DataManager.sharedDataManager.isRequiredLoadNextPage = false
            self.showAlertView(title: "Error", message: error.localizedDescription)
        }

        
    }

    //MARK:- Alert local
    private func showAlertView(title: String!, message : String!) {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil)
        alertView.show()
        alertView.closAlertAfterDelay(delayInSeconds: 3.0)
    }

    private func populateDataOnUI(jsonData : JSON) {
        
        self.particularProductDetail = jsonData
        
        let url  = URL(string:jsonData["product"]["img_url"].stringValue)
        
        //Product Image
        self.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.cacheMemoryOnly)
        self.productImageView.layer.masksToBounds = true
        self.productImageView.layer.cornerRadius = 5.0
        self.productImageView.layer.borderColor = kGRAY_COLOR.cgColor
        self.productImageView.layer.borderWidth = 0.5
        

        
        //Product Name
        self.productNameLabel.text = jsonData["product"]["name"].stringValue
        self.productNameLabel.sizeToFit()
        
        //Product Price
        let tempString = self.numberFormatter.string(from: NSNumber(value:Int(jsonData["product"]["price"].doubleValue) as NSInteger!))!
        self.productPriceLabel.text =  tempString
        self.addToCartButton.isHidden = false
        if(jsonData["product"]["under_sale"].stringValue == "true") {
            self.productAvailabilityLabel.text = "Available"
            self.productAvailabilityLabel.textColor = kGREEN_COLOR
//            self.addToCartButton.hidden = false
            
        }else {
            self.productAvailabilityLabel.text = "Unavailable"
            self.productAvailabilityLabel.textColor = kRED_COLOR
        }
        self.productDescriptionLabel.text = jsonData["product"]["description"].stringValue
        self.productDescriptionLabel.sizeToFit()

    }

}
