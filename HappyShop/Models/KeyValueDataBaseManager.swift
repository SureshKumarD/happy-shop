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

    //Create or Update the entity 'KeyValueManager' with the given key-value.
    class func saveObject(key : String!, objectString : String!) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //Check if the key is already available...
        let tuple = KeyValueDataBaseManager.objectStringForKey(key: key)
        
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
            
            let entity =  NSEntityDescription.entity(forEntityName: kENTITY_KEY_VALUE_MANAGER, in: managedContext)
            let keyValueTuple = NSManagedObject(entity: entity!, insertInto: managedContext)
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
    
    
    class func objectStringForKey(key : String!)-> (valueString : String?, managedObject : AnyObject?) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: kENTITY_KEY_VALUE_MANAGER)
        let predicate = NSPredicate(format: "%K == %@", KEY, key)
        fetchRequest.predicate = predicate
        
        var fetchResult : NSAsynchronousFetchResult<NSFetchRequestResult>
        
        
        do {
            fetchResult = try managedContext.execute(fetchRequest) as! NSAsynchronousFetchResult<NSFetchRequestResult>
        }catch {
            fatalError("Failure to fetch requested key:\(key) - \(error)")
        }
        
        //If the key given in the predicate exists...
        if((fetchResult.finalResult?.count)! > 0 ) {
            
            let resultObject = fetchResult.finalResult?[0] as AnyObject
            return (fetchResult.value(forKey: VALUE) as! String?, resultObject as AnyObject)
        }else {
            //If key is not exists...
            
            return (nil, nil)
        }
        

        
    }
}
