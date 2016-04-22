//
//  KeyValueDataBaseManager.swift
//  HappyShop
//
//  Created by Suresh on 4/23/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import CoreData

let kCART_ITEMS_KEY = "cart_items_key"
let kENTITY_KEY_VALUE_MANAGER = "KeyValueManager"


class KeyValueDataBaseManager: NSObject {

    
    class func saveObject(key : String!, objectString : String!) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName(kENTITY_KEY_VALUE_MANAGER, inManagedObjectContext: managedContext)
        let keyValueTuple = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        keyValueTuple.setValue(key, forKey: "mKey")
        keyValueTuple.setValue(objectString, forKey: "mValue")
        // save current tuple...
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    
    class func objectStringForKey(key : String!)-> String! {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: kENTITY_KEY_VALUE_MANAGER)
        let predicate = NSPredicate(format: "%K == %@", "mKey", key)
        fetchRequest.predicate = predicate
        
        var fetchResult : [AnyObject]?
        do {
            fetchResult = try managedContext.executeFetchRequest(fetchRequest)
        }catch {
            fatalError("Failure to fetch requested key:\(key) - \(error)")
        }
        if(fetchResult?.count > NUMBER_ZERO) {
            return fetchResult?[0].valueForKey("mValue") as? String!
        }else {
            return ""
        }
        

        
    }
}
