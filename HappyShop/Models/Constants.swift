//
//  Constants.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import Foundation

//Configuration Constants...
let URL_BASE  = "https://sephora-mobile-takehome-2.herokuapp.com"
let API_VERSION = "v1"
let URL_FRAGMENT_API = "api"
let URL_DATA_PRODUCTS = "products"
let URL_FRAGMENT_JSON  = ".json"




//Replace your API_KEY with the empty string below...
let API_KEY = ""

//Other Constants...
let NUMBER_ZERO = 0
let NUMBER_ONE = 1
let NUMBER_TWO = 2
let NUMBER_THREE = 3
let NUMBER_FOUR = 4
let NUMBER_FIVE = 5

//Frame windo...
let WIDTH_WINDOW_FRAME =  UIScreen.mainScreen().bounds.size.width
let HEIGHT_WINDOW_FRAME =  UIScreen.mainScreen().bounds.size.height

//Colors...
let kCLEAR_COLOR = UIColor.clearColor()
let kBLACK_COLOR = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
let kGRAY_COLOR = UIColor(red: 102/255, green: 102/255, blue: 108/255, alpha: 1.0)
let kGRAY_COLOR2 = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 1.0)
let kWHITE_COLOR = UIColor.whiteColor()
let kSUB_TEXT_COLOR = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1.0)
let kWHITE_COLOR2 = UIColor(red: 255/255, green: 250/255, blue: 240/255, alpha: 1.0)
let kLINEN_COLOR = UIColor(red: 250/255, green: 240/255, blue: 230/255, alpha: 1.0)

let kSEA_SHELL_COLOR = UIColor(red: 255/255, green: 245/255, blue: 238/255, alpha: 1.0)
let kSEA_SHELL_COLOR2 = UIColor(red: 238/255, green: 229/255, blue: 222/255, alpha: 1.0)
let kSNOW_COLOR = UIColor(red: 255/255, green: 250/255, blue: 250/255, alpha: 1.0)
let kGREEN_COLOR = UIColor(red: 18/255, green: 181/255, blue: 138/255, alpha: 1.0)
let kRED_COLOR = UIColor(red: 243/255, green: 55/255, blue: 62/255, alpha: 1.0)
let kPINK_COLOR = UIColor(red: 255/255, green: 240/255, blue: 245/255, alpha: 1.0)



//Others..
let kCURRENCY_SYMBOL = "\u{0024}"
let kCART_ITEMS = "cart_items"
let kCART_ITEMS_KEY = "cart_items_key"


/* ========= ENUMS =================== */
enum ProductListingOptions: Int {
    case Grid = 0, List
}
