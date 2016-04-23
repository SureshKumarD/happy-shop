//
//  NetworkManagerTests.swift
//  HappyShop
//
//  Created by Suresh on 4/24/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import HappyShop

class NetworkManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    //NetworkManager's products server call asynchronous and time delay verification
    func testProductsGetFromServer() {
        
        let completionException = self.expectationWithDescription(" Failed : Get Products From Server - for the cateogory 'Makeup' and page '1'") as XCTestExpectation
        let params = [ "category" : "Makeup", "page": "1"]
        let urlString = "/api/v1/products.json"
        NetworkManager.getFromServer(urlString, params: params, success: { (JSON) -> Void in
            completionException.fulfill()
            
            }) { (NSError) -> Void in
                
                
        }
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
        
    }
    
    //NetworkManager's particular product's server call asynchronous and time delay verification
    func testProductGetFromServer() {
        
        let completionException = self.expectationWithDescription(" Failed : Get Product From Server - for the id '7'") as XCTestExpectation
        let params = [:] as [String : String]
        let urlString = "/api/v1/products/7.json"
        NetworkManager.getFromServer(urlString, params: params, success: { (JSON) -> Void in
            completionException.fulfill()
            
            }) { (NSError) -> Void in
                
                
        }
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
        
    }

}
