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
let kCELL_HEIGHT_NO_ITEM = 60 as CGFloat

let kHEADER_HEIGHT = 44 as CGFloat

class ShoppingBagViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SelectedItemDelegate {

    @IBOutlet weak var headerContainerView: UIView!
    
    //Interface Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var itemsTableView: UITableView!
    
    //Store saved items to display the summary...
    private var shoppedItems : [JSON] = [ ]
    
    //Header view to be passed in the tableview's header
    private var headerView : UIView!
    
    //Quantity...
    private var quantityTableView : UITableView!
    private var isQuantityTableVisible : Bool!
    private var selectedProductIndex : Int!
    
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //Remove the quantity tableview from TableView
        self.quantityTableView.removeFromSuperview()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- METHODS
    
    private func initializations() {
        self.scrollView.delegate = self
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        self.itemsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.itemsTableView.allowsSelection = false
        self.itemsTableView.backgroundColor = kWHITE_COLOR
        self.headerContainerView.layer.masksToBounds = true
        self.headerContainerView.layer.cornerRadius = 5.0
        self.headerContainerView.layer.borderColor = kGRAY_COLOR.CGColor
        self.headerContainerView.layer.borderWidth = 0.5
        
        let frame = CGRect(x: ((WIDTH_WINDOW_FRAME / 2) - 30), y: ((HEIGHT_WINDOW_FRAME/2) - 396/2), width: 60, height: 396)
        self.quantityTableView = UITableView(frame: frame, style: UITableViewStyle.Plain)
        self.quantityTableView.delegate = self
        self.quantityTableView.dataSource = self
        self.quantityTableView.backgroundColor = kCLEAR_COLOR;
        self.isQuantityTableVisible = false
        
        self.initializeTableHeaderView()
        self.loadShoppedItemsArray()
        
    }
    
    private func initializeTableHeaderView() {
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
    override func didFinishLayout() {
        DataManager.sharedDataManager().setGradientBackgroundColor(self.headerContainerView)
    }
    
    private func loadShoppedItemsArray() {
        self.shoppedItems = []
        let shoppingBagItems = DataManager.sharedDataManager().selectedProductList
        var totalAmount : Double = 0.0
        var totalCount : Int = 0
        for (_, subJson) in shoppingBagItems {
            var quantity = (subJson["product"]["quantity"].intValue)
            if(quantity == 0) {
                quantity = 1
            }
            totalCount += quantity
            totalAmount += Double(quantity) *  (subJson["product"]["price"].doubleValue)
            self.shoppedItems.append(subJson)
            
        }
        self.totalItemsLabel.text = "Total Items  : "+"\(totalCount)"
        
        let tempString = self.numberFormatter.stringFromNumber(NSNumber(integer:Int(totalAmount))) as String!
        self.totalAmountLabel.text = "Total Amount  : "+tempString
       
        
    }
    //MARK:- TableView Datasources
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUMBER_ONE
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.quantityTableView) {
            return 9
        }else {
            var itemsCount = self.shoppedItems.count
            if itemsCount == NUMBER_ZERO {
                itemsCount = NUMBER_ONE
            }
            return itemsCount
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(tableView == self.quantityTableView) {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("QuantityCell") as? QuantityCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "QuantityCell", bundle: nil), forCellReuseIdentifier: "QuantityCell")
                cell = tableView.dequeueReusableCellWithIdentifier("QuantityCell") as? QuantityCell
            }
            
            cell?.quantityCountLabel.text = "\(indexPath.row + NUMBER_ONE)"
            cell?.quantityCountLabel.tag = indexPath.row
            cell?.selectionStyle = .None
            return cell!
            
        }else {
            //TODO:- Returns 'no items in your bag' messaged cell,
            //If the 'shoppedItems' array count is 0
            if(self.shoppedItems.count == NUMBER_ZERO) {
                let cell = tableView.dequeueReusableCellWithIdentifier("NoItemsCell")
                return cell!
            }
            
            //Else the 'ShoppedItems' array count is > 0
            //Returns data populated 'ShoppedItemCell'
            var cell = tableView.dequeueReusableCellWithIdentifier("ShoppedItemCell") as? ShoppedItemCell
            
            if cell == nil {
                tableView.registerNib(UINib(nibName: "ShoppedItemCell", bundle: nil), forCellReuseIdentifier: "ShoppedItemCell")
                cell = tableView.dequeueReusableCellWithIdentifier("ShoppedItemCell") as? ShoppedItemCell
                cell?.productNameLabel.sizeToFit()
            }
            
            //JSON object unwrapped from array...
            let productObject = self.shoppedItems[indexPath.row]
            
            //Configure cell's subviews data...
            self.configureShoppingBagTableView(&cell!, productObject: productObject, index: indexPath.row)
            
            //Return the data populated cell...
            return cell!

            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(tableView == self.quantityTableView) {
            return 44
        }else {
            let itemsCount = self.shoppedItems.count
            if itemsCount == NUMBER_ZERO {
                return kCELL_HEIGHT_NO_ITEM
            }
            return kCELL_HEIGHT_DEFAULT
        }
        
       
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(tableView == self.quantityTableView) {
            return 0
        }else {
            return kHEADER_HEIGHT
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableView == self.quantityTableView) {
            return nil
        }else {
            return self.headerView
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
         if(tableView == self.quantityTableView) {
            self.showOrHideQuantityTableView(indexPath.row + NUMBER_ONE)
        }
        
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

    private func configureShoppingBagTableView(inout cell : ShoppedItemCell, productObject : JSON , index : Int) {
        let url  = NSURL(string:  productObject["product"]["img_url"].stringValue)
        
        //Product Image
        cell.productImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.CacheMemoryOnly)
        
        //Product Name
        cell.productNameLabel.text = productObject["product"]["name"].stringValue
        cell.productNameLabel.sizeToFit()
        
        //Product Price
        let tempString = self.numberFormatter.stringFromNumber(NSNumber(integer:Int(productObject["product"]["price"].stringValue) as NSInteger!))!
        cell.productPriceLabel.text =  tempString
        
        //Setting button's tag as index
        cell.productRemoveButton.tag = index
        
        //Setting delegate to get remove items.
        cell.removeItemDelegate = self
        
        
        //Quantity...
        //Quantity Button
        cell.quantityCountButton.tag = index

        var quantityCount = productObject["product"]["quantity"].stringValue
        if(quantityCount.isEmpty) {
            quantityCount = "1"
        }
       
        //Set the quantityCountButton.
        cell.quantityCountButton.setTitle("Nos. "+quantityCount, forState: .Normal)
        

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
    
    func quantityButtonTappedAt(index: Int) {
        
        self.selectedProductIndex = index
        
        self.showOrHideQuantityTableView(index)
    }
    
    //Save items in shopping bag...
    private func saveShoppingItems() {
        
        var cartItems = DataManager.sharedDataManager().selectedProductList.rawString()
        print("Success : cart items" + "\(cartItems)")
        
        if (DataManager.sharedDataManager().selectedProductList.isEmpty == true ) {
        
            cartItems = nil
        }
        
        //Save the updated object string in database...
        
        //Deliberately converting all the data in hand to string(json object string),
        //To make the Coredata updation simple and faster.
        //And the converted string will be replaced with the old string based on
        //the key kCART_ITEMS_KEY.
        KeyValueDataBaseManager.saveObject(kCART_ITEMS_KEY, objectString: cartItems)
        
        //Load the itemsarray with updated value
        self.loadShoppedItemsArray()
        
        //Reload the tableview...
        self.itemsTableView.reloadData()
        
    }
    
    
    private func showOrHideQuantityTableView(index : Int) {
        
        //Hide the quantity tableview...
        if(self.isQuantityTableVisible == true) {
            
            //Make the background tangible
            self.view.userInteractionEnabled = true
            self.view.alpha = 1.0

            var jsonObject = self.shoppedItems[self.selectedProductIndex] as JSON
            let productId = jsonObject["product"]["id"].stringValue
            jsonObject["product"]["quantity"].intValue = index
            
            let sharedDataInstance = DataManager.sharedDataManager()
            
            //Replace the particular object with the updated quantity
            sharedDataInstance.selectedProductList[productId] = jsonObject

            //Stoer it in DB...
            self.saveShoppingItems()

            //Remove the quantity tableview from TableView
            self.quantityTableView.removeFromSuperview()
            
            //Set the isQuantityTableVisible flag to false
            self.isQuantityTableVisible = false
            
        }else {
            //Unhide the quantity tableview...
            
            //Make the background intangible, before adding quantity tableview...
            self.view.userInteractionEnabled = false
            self.view.alpha = 0.2
            
            //Add the quantity tableview on the window tableview...
            let mainWindow = UIApplication.sharedApplication().keyWindow
            mainWindow?.addSubview(self.quantityTableView)
            
            //Set the isQuantityTableVisible falg to true
            self.isQuantityTableVisible = true
        }
        
        
    }
}
