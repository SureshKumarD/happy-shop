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
    private let numberFormatter = NumberFormatter()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.numberFormatter.numberStyle = NumberFormatter.Style.currency
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
        self.numberFormatter.numberStyle = NumberFormatter.Style.decimal
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CollectionView Datasources
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return NUMBER_ONE
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.productsArray.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionCell", for: indexPath as IndexPath) as! ProductsCollectionCell
        
        //JSON object unwrapped from array...
        let productObject = self.productsArray[indexPath.row]
        
        //Configure cell's subviews data...
        self.configureProductsCollection(cell: &cell, productObject: productObject)
        
        //Return the data populated cell...
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: WIDTH_WINDOW_FRAME/2 - 0.5, height: WIDTH_WINDOW_FRAME/2 + 50)
    }
    
    //MARK:- CollectionView Delegates
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = self.productsArray[indexPath.row]
        self.productDelegate.productSelected(product: object)
    }
    
    
    
    //Cell Cutomizations...
    
    private func configureProductsCollection(cell : inout ProductsCollectionCell, productObject : JSON) {
        let url  = URL(string:  productObject["img_url"].stringValue) as URL!
        
        //Product Image
        cell.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named:"placeholder"), options: SDWebImageOptions.cacheMemoryOnly)

        
        //Product Name
        cell.productNameLabel.text = productObject["name"].stringValue
        
        //Product Price
        let tempString = self.numberFormatter.string(from: NSNumber(value:Int(productObject["price"].stringValue) as NSInteger!))!
        cell.productPriceLabel.text =  tempString
        
        if(productObject["under_sale"].stringValue == "true") {
            cell.productAvailabilityLabel.text = "Available"
            cell.productAvailabilityLabel.textColor = kGREEN_COLOR
            
        }else {
            cell.productAvailabilityLabel.text = "Unavailable"
            cell.productAvailabilityLabel.textColor = kRED_COLOR
        }

    }
    
    //MARK: - SUPERCLASS's method overriden
   
    override  func reloadTableOrCollectionView(objects: [AnyObject]!) {
        let jsonObjects = JSON(objects).arrayValue
        self.productsArray += jsonObjects
        self.reloadData()
    }
    
    
    
}
