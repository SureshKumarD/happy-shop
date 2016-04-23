//
//  ProductsTableView.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import SwiftyJSON

public class ProductsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    
    //local object
    public var productsArray :[JSON] = []
    
    //variable product delegate...
    var productDelegate : ProductDelegate!
    
    //Number Formatter - (comma , )separated numbers...
    private let numberFormatter = NSNumberFormatter()
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        self.backgroundColor = kBLACK_COLOR
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = kBLACK_COLOR
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- TableView Datasources
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUMBER_ONE
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productsArray.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ProductsTableCell") as? ProductsTableCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "ProductsTableCell", bundle: nil), forCellReuseIdentifier: "ProductsTableCell")
            cell = tableView.dequeueReusableCellWithIdentifier("ProductsTableCell") as? ProductsTableCell
            cell?.productNameLabel.sizeToFit()
        }
        
        //JSON object unwrapped from array...
        let productObject = self.productsArray[indexPath.row]
        
        //Configure cell object's data...
        self.configureProductsCell(&cell!, productObject: productObject)
        
        //Return the data populated cell...
        return cell!

    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Remove seperator inset
        if(cell.respondsToSelector(Selector("setSeparatorInset:")) == true) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if(cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) == true) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if(cell.respondsToSelector(Selector("setLayoutMargins:")) == true) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        // Draw cell border of height 1px.
        let borderFrame : CGRect = CGRect(x: 0, y: cell.frame.size.height - 0.5, width: cell.frame.size.width, height: 0.5)
        let separatorView = UIView(frame:borderFrame)
        separatorView.backgroundColor = kGRAY_COLOR2
        cell .addSubview(separatorView)
    }
  
    
    //MARK:- TableView Delegates
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = self.productsArray[indexPath.row]
        self.productDelegate.productSelected(object)
    }
    
    
    //Cell Customization...
    private func configureProductsCell(inout cell : ProductsTableCell , productObject : JSON ) {
        
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

    }
    
    //MARK: - SUPERCLASS's method overriden
    override func reloadTableOrCollectionView(objects: [AnyObject]!) {
        let jsonObjects = JSON(objects).arrayValue
        self.productsArray += jsonObjects
        self.reloadData()
    }


}
