//
//  NetworkManager.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class NetworkManager: NSObject {

    //MARK: - Server Call
    // Common Get request from server
    // Fetches list of products/ particular product info.
    class func getFromServer(urlString : String, params: [String : String], success: @escaping (AnyObject?)-> Void, failure :@escaping ( NSError)->Void) {
        let url = URL(string: URL_BASE+urlString)! as URL
        Alamofire.request(
            url,
            method: .get,
            parameters: nil)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    success(nil)
                    return
                }
                
                guard let resultValue = response.result.value as? AnyObject,
                    let rows = resultValue["products"] as? [[String: Any]] else {
                        print("Malformed data received from fetchAllRooms service")
                        success(nil)
                        return
                }
                
                success(rows as AnyObject?)
        }
        
    }
}
