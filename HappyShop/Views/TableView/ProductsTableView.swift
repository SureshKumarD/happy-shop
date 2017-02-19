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
    private let numberFormatter = NumberFormatter()
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = UITableViewCellSeparatorStyle.none
        self.numberFormatter.numberStyle = NumberFormatter.Style.currency
        self.backgroundColor = kBLACK_COLOR
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = kBLACK_COLOR
        self.numberFormatter.numberStyle = NumberFormatter.Style.currency
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- TableView Datasources
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUMBER_ONE
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productsArray.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableCell") as? ProductsTableCell
        if cell == nil {
            
            tableView.register(UINib(nibName: "ProductsTableCell", bundle: nil), forCellReuseIdentifier: "ProductsTableCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableCell") as? ProductsTableCell
        
            cell?.productNameLabel.sizeToFit()
        }
        
        //JSON object unwrapped from array...
        let productObject = self.productsArray[indexPath.row]
        
        //Configure cell object's data...
        self.configureProductsCell(cell: &cell!, productObject: productObject)
    
        
        //Return the data populated cell...
        return cell!

    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Remove seperator inset
        if(cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) == true) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if(cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) == true) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if(cell.responds(to: #selector(setter: UIView.layoutMargins)) == true) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        // Draw cell border of height 1px.
        let borderFrame : CGRect = CGRect(x: 0, y: cell.frame.size.height - 0.5, width: cell.frame.size.width, height: 0.5)
        let separatorView = UIView(frame:borderFrame)
        separatorView.backgroundColor = kGRAY_COLOR2
        cell .addSubview(separatorView)
    }
    
    
    //MARK:- TableView Delegates
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.productsArray[indexPath.row]
        self.productDelegate.productSelected(product: object)
    }
    
    
    //Cell Customization...
    private func configureProductsCell(cell : inout ProductsTableCell , productObject : JSON ) {
        
        let url  = URL(string:  productObject["img_url"].stringValue) as URL!
        
        //Product Image
        cell.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named:"placeholder"), options: SDWebImageOptions.cacheMemoryOnly)
//        cell.productImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.cacheMemoryOnly)
        
        //Product Name
        cell.productNameLabel.text = productObject["name"].stringValue
        
        //Product Price
        let tempString = self.numberFormatter.string(from: NSNumber(value: productObject["price"].intValue))
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
