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

let KEY = "mKey"
let VALUE = "mValue"


class KeyValueDataBaseManager: NSObject {

    //TODO:- Create or Update the entity 'KeyValueManager' with the given key-value.
    class func saveObject(key : String!, objectString : String!) {
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //Check if the key is already available...
        let tuple = KeyValueDataBaseManager.objectStringForKey(key)
        
        //Update the managedObject since if it already exists...
        if(tuple.managedObject != nil ) {
            tuple.managedObject?.setValue(kCART_ITEMS_KEY, forKey: KEY)
            tuple.managedObject?.setValue(objectString, forKey: VALUE)
            // save current tuple...
            do {
                try managedContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }

        }else {
            //Create a new tuple for the given key-value data...
            
            let entity =  NSEntityDescription.entityForName(kENTITY_KEY_VALUE_MANAGER, inManagedObjectContext: managedContext)
            let keyValueTuple = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            keyValueTuple.setValue(key, forKey: KEY)
            keyValueTuple.setValue(objectString, forKey: VALUE)
            // save current tuple...
            do {
                try managedContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }

        }
        
        
    }
    
    
    class func objectStringForKey(key : String!)-> (valueString : String!, managedObject : AnyObject?) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: kENTITY_KEY_VALUE_MANAGER)
        let predicate = NSPredicate(format: "%K == %@", KEY, key)
        fetchRequest.predicate = predicate
        
        var fetchResult : [AnyObject]?
        do {
            fetchResult = try managedContext.executeFetchRequest(fetchRequest)
        }catch {
            fatalError("Failure to fetch requested key:\(key) - \(error)")
        }
        
        //If the key given in the predicate exists...
        if(fetchResult?.count > NUMBER_ZERO) {
            
            let resultObject = fetchResult![0]
            return (resultObject.valueForKey(VALUE) as! String?, resultObject as AnyObject)
        }else {
            //If key is not exists...
            
            return (nil, nil)
        }
        

        
    }
}
