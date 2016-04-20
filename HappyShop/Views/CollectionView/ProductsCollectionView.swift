//
//  ProductsCollectionView.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import SwiftyJSON

public class ProductsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    //local object
    public var productsArray :[JSON] = []
    
    //variable product delegate...
    var productDelegate : ProductDelegate!
    
    //Number Formatter - (comma , )separated numbers...
    let numberFormatter = NSNumberFormatter()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CollectionView Datasources
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return NUMBER_ONE
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.productsArray.count
    }
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductsCollectionCell", forIndexPath: indexPath) as! ProductsCollectionCell
        
        let productObject = self.productsArray[indexPath.row]
        
        let url  = NSURL(string:  productObject["img_url"].stringValue)

        //Product Image
        cell.productImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.CacheMemoryOnly)
        
        //Product Name
        cell.productNameLabel.text = productObject["name"].stringValue

        //Product Price
        let tempString = self.numberFormatter.stringFromNumber(NSNumber(integer:Int(productObject["price"].stringValue) as NSInteger!))!
        cell.productPriceLabel.text =  tempString
        
        if(productObject["under_sale"].stringValue == "true") {
            cell.productAvailabilityLabel.text = "Available"
            cell.productAvailabilityLabel.textColor = kGREEN_COLOR
            
        }else {
            cell.productAvailabilityLabel.text = "Unavailable"
            cell.productAvailabilityLabel.textColor = kRED_COLOR
        }

        return cell
    }
    
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((WIDTH_WINDOW_FRAME/2 - 0.5), WIDTH_WINDOW_FRAME/2 + 50)
       
    }
    
    //MARK:- CollectionView Delegates
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let object = self.productsArray[indexPath.row]
        self.productDelegate.productSelected(object)
    }
    
    //MARK: - SUPERCLASS's method overriden
   
    override  func reloadTableOrCollectionView(objects: [AnyObject]!) {
        let jsonObjects = JSON(objects).arrayValue
        self.productsArray += jsonObjects
        self.reloadData()
    }
    
    
    
}
