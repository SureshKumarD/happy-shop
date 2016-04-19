//
//  Protocols.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol CategoryDelegate : class {
    
    func categorySelected(item:AnyObject!)->Void
    
}

protocol ProductDelegate : class {
    
    func productSelected(product: JSON!)->Void
    
}

