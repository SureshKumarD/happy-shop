//
//  DataManagerTests.swift
//  HappyShop
//
//  Created by Suresh on 4/24/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import HappyShop

class DataManagerTests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    //DataManager's ConvertStringToJSON assertion test.
    func testConvertStringToJSON() {
        
        let testString = "{ \"23\" : { \"name\" : \"Sample_Product_Name\", \"price\" : \"2500\" }}"
        
        let resultJsonObject =  DataManager.convertStringToJSON(testString)! as JSON
        let expectedJsonObjectString =  "{\n  \"23\" : {\n    \"name\" : \"Sample_Product_Name\",\n    \"price\" : \"2500\"\n  }\n}"
        XCTAssertEqual(resultJsonObject.rawString()!, expectedJsonObjectString, "The string to json conversion goes wrong at DataManager Class method")
    
    }
    
    //DataManager's ConvertStringToJSON performance test.
    func testPerformanceConvertStringToJSON() {
        
        let testString = "{ \"23\" : { \"name\" : \"Sample_Product_Name\", \"price\" : \"2500\" }}"
        self.measureBlock { () -> Void in
            _ =  DataManager.convertStringToJSON(testString)! as JSON
        }
        
        
    }
        
        
    
    
}
