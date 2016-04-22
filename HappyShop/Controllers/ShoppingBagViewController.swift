//
//  ShoppingBagViewController.swift
//  HappyShop
//
//  Created by Suresh on 4/22/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import SwiftyJSON

let kCELL_HEIGHT_DEFAULT = 170 as CGFloat
let kCELL_HEIGHT_NO_ITEM = 170 as CGFloat

let kHEADER_HEIGHT = 44 as CGFloat

class ShoppingBagViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SelectedItemDelegate {

    
    //Interface Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var itemsTableView: UITableView!
    
    
    var shoppedItems : [JSON] = [ ]
    
    var headerView : UIView!
    
    //Number Formatter - (comma , )separated numbers...
    let numberFormatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Allocations or initializations of required objects...
        self.initializations()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationTitle("Shopping Bag")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadShoppedItemsArray()
        self.itemsTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- METHODS
    
    func initializations() {
        self.scrollView.delegate = self
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        self.itemsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.itemsTableView.allowsSelection = false
        self.itemsTableView.backgroundColor = kWHITE_COLOR
        self.initializeTableHeaderView()
        self.loadShoppedItemsArray()
        
    }
    
    func initializeTableHeaderView() {
        self.headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH_WINDOW_FRAME, height: 44))
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width: WIDTH_WINDOW_FRAME - 30, height: 43))
        headerLabel.textColor = kBLACK_COLOR
        headerLabel.backgroundColor = kWHITE_COLOR
        headerLabel.font = UIFont(name: "HelveticaNeue", size: 15)
        headerLabel.text = "Shopping bag items"
        headerLabel.textAlignment = NSTextAlignment.Left
        let borderLabel = UILabel(frame: CGRect(x: 0, y: 43.5, width: WIDTH_WINDOW_FRAME, height: 0.5))
        borderLabel.backgroundColor = kGRAY_COLOR2
        
        self.headerView.addSubview(headerLabel)
        self.headerView.addSubview(borderLabel)
        
    }
    
    func loadShoppedItemsArray() {
        self.shoppedItems = []
        let shoppingBagItems = DataManager.sharedDataManager().selectedProductList
        var totalAmount : Double = 0.0
        for (key, subJson) in shoppingBagItems {
            totalAmount += subJson["product"]["price"].doubleValue
            self.shoppedItems.append(subJson)
            
        }
        self.totalItemsLabel.text = "Total Items  : "+"\(shoppedItems.count)"
        
        let tempString = self.numberFormatter.stringFromNumber(NSNumber(integer:Int(totalAmount))) as String!
        self.totalAmountLabel.text = "Total Amount  : "+tempString
       
        
    }
    //MARK:- TableView Datasources
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUMBER_ONE
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var itemsCount = self.shoppedItems.count
        if itemsCount == NUMBER_ZERO {
            itemsCount = NUMBER_ONE
        }
        return itemsCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(self.shoppedItems.count == NUMBER_ZERO) {
            let cell = tableView.dequeueReusableCellWithIdentifier("NoItemsCell")
            return cell!
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ShoppedItemCell") as? ShoppedItemCell
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: "ShoppedItemCell", bundle: nil), forCellReuseIdentifier: "ShoppedItemCell")
            cell = tableView.dequeueReusableCellWithIdentifier("ShoppedItemCell") as? ShoppedItemCell
        }
        let productObject = self.shoppedItems[indexPath.row]
        let url  = NSURL(string:  productObject["product"]["img_url"].stringValue)
        
        //Product Image
        cell?.productImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.CacheMemoryOnly)
        
        //Product Name
        cell?.productNameLabel.text = productObject["product"]["name"].stringValue
        
        //Product Price
        let tempString = self.numberFormatter.stringFromNumber(NSNumber(integer:Int(productObject["product"]["price"].stringValue) as NSInteger!))!
        cell?.productPriceLabel.text =  tempString
        
        //Setting button's tag as index
        cell?.productRemoveButton.tag = indexPath.row
        
        //Setting delegate to get remove items.
        cell?.removeItemDelegate = self
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var itemsCount = self.shoppedItems.count
        if itemsCount == NUMBER_ZERO {
           return kCELL_HEIGHT_NO_ITEM
        }
        return kCELL_HEIGHT_DEFAULT
       
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHEADER_HEIGHT
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
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
        let borderFrame : CGRect = CGRect(x: 15, y: cell.frame.size.height - 0.5, width: cell.frame.size.width - 30, height: 0.5)
        let separatorView = UIView(frame:borderFrame)
        separatorView.backgroundColor = kGRAY_COLOR2
        cell.addSubview(separatorView)
    }


    //MARK:- Selected Item Delegate
    func removeItemAtIndex(index: Int) {
        print("selected item index" + "\(index)")
        
        let jsonObject = self.shoppedItems[index]
        let productId = jsonObject["product"]["id"].stringValue
        let sharedDataInstance = DataManager.sharedDataManager()
        sharedDataInstance.selectedProductList.dictionaryObject?.removeValueForKey(productId)
        self.saveShoppingItems()
    }
    
    //Save items in shopping bag...
    func saveShoppingItems() {
        if let cartItems = DataManager.sharedDataManager().selectedProductList.rawString() {
            do {
                
                print("Success : cart items" + "\(cartItems)")
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue(cartItems, forKey: kCART_ITEMS_KEY)
                defaults.synchronize()
                self.loadShoppedItemsArray()
                self.itemsTableView.reloadData()
                
            } catch let error as NSError {
                print("error in unwrapping cartitems " + error.localizedDescription)
            }
            
        }
        
    }


   
}
