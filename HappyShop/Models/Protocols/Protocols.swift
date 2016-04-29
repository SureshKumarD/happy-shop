//
//  Protocols.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import Foundation
import SwiftyJSON

//HomeViewController - CategoriesCollectionView.
protocol CategoryDelegate : class {
    
    func categorySelected(item:AnyObject!)->Void
    
}

//ProductsViewController - ProductsCollectionView, ProductsTableView.
protocol ProductDelegate : class {
    
    func productSelected(product: JSON!)->Void
    
}


//ShoppingBagViewController - ShoppedItemCell.
protocol SelectedItemDelegate : class {
    
    func removeItemAtIndex(index : Int)->Void
    
    func quantityButtonTappedAt(index :Int)->Void
}

