//
//  CategoriesCollectionView.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit

public class CategoriesCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    //local object
    public var categoriesArray : [AnyObject] = DataManager.sharedDataManager().categoriesArray
    
    //Number Formatter - (comma , )separated numbers...
    let numberFormatter = NSNumberFormatter()
    
    //Delegate to pass data
    var categoryDelegate : CategoryDelegate!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = kCLEAR_COLOR
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CollectionView Datasources
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return NUMBER_ONE
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoriesArray.count
    }
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CategoriesCollectionCell", forIndexPath: indexPath) as! CategoriesCollectionCell
        
        let category = self.categoriesArray[indexPath.row]
        cell.categoryNameLabel.text = category as? String
        
        return cell
    }
    
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if(indexPath.row % 3 == NUMBER_ZERO) {
            return CGSizeMake((WIDTH_WINDOW_FRAME - 2), WIDTH_WINDOW_FRAME/2)
        }else {
            return CGSizeMake((WIDTH_WINDOW_FRAME/2 - 0.5), WIDTH_WINDOW_FRAME/2)
        }
        
        
    }
    
    //MARK:- CollectionView Delegates
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            let object = self.categoriesArray[indexPath.row]
            self.categoryDelegate.categorySelected(object)
    }
    


}
