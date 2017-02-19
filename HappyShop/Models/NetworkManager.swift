//
//  NetworkManager.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import SwiftyJSON

class NetworkManager: NSObject {

    //MARK: - Server Call
    // Common Get request from server
    // Fetches list of products/ particular product info.
    class func getFromServer(urlString : String, params: [String : String], success: @escaping (JSON)-> Void, failure :@escaping ( NSError)->Void) {
        
        //Uses RESTful approach, ie., BaseUrl + Url fragment...
        let manager = AFHTTPSessionManager(baseURL: URL(string:URL_BASE))
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
    
        //Setting Possible Acceptable Content Types
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/plain","application/json", "text/json", "text/javascript", "text/html","text/xml"]) as? Set<String>
        
        /*
        // Add common parameters, along with the existing parameters...
        let composedParams = NetworkManager.addCommonParameter(params)
        */
        manager.get(urlString, parameters: params , progress: nil, success: {
            (task: URLSessionDataTask, responseObject: Any!) in
            
            //TODO: - Check for valid response.
            if let responseDict = responseObject as? Dictionary<String, AnyObject> {
                let response = JSON(responseDict)
                
                //Success call back to the caller...
                success(response)
            }
            else {
                
                //Log to acknowledge developer.
                print("Unrecognized data received")
            }
            }, failure: {
                (task: URLSessionDataTask?, error: Error) in
                
                //Log to acknowledge developer.
                print("error")
                
                //Failure callback to the caller...
                failure( error as NSError)
        })
        
    }
    
    /*
    class func addCommonParameter(params:[String : String])-> [String : String] {
        var composedDictionary = params
        // If the API_KEY is provided, interpolated the existing dictionary,
        // with the new atom appid-api_key...
        if(!(API_KEY.isEmpty)) {
            composedDictionary["appid"] = API_KEY
        }
        return composedDictionary
        
    }
    */

}
