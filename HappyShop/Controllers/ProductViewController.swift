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
    
    //Number Formatter - (comma , )separated numbers...
    let numberFormatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initializations or Allocations...
        self.initializations()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set the navigation bar title...
        self.title = particularProductJSON["name"].stringValue
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Get the particular product detail from server...
        self.getProductFromServer()
    }
    
    //MARK:- METHODS
    
    //MARK:- Add To Cart Tapped
    @IBAction func addToCartButtonTapped(sender: AnyObject) {
        
        
        
    }
    
    //MARK:- Initialization or Allocations of objects
    func initializations() {
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        self.productImageView.backgroundColor = kWHITE_COLOR
        self.productImageView.layer.masksToBounds = true
        self.productImageView.layer.cornerRadius = CGFloat(NUMBER_FIVE)
        self.productImageView.layer.borderColor = kWHITE_COLOR.CGColor
        self.productImageView.layer.borderWidth = CGFloat(NUMBER_ONE)
        
        //Hide Add to cart button...
        self.addToCartButton.hidden = true
        
        //Avoid self.view goes underneath navigationbar
        self.navigationController?.navigationBar.translucent = false
        
       
        
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
