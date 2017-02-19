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
    public var categoriesArray : [AnyObject] = DataManager.sharedDataManager.categoriesArray as [AnyObject]
    
    //Number Formatter - (comma , )separated numbers...
    private let numberFormatter = NumberFormatter()
    
    //Delegate to pass data
    var categoryDelegate : CategoryDelegate!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = kCLEAR_COLOR
        self.numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CollectionView Datasources
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return NUMBER_ONE
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoriesArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath as IndexPath) as! CategoriesCollectionCell
//        DataManager.sharedDataManager().setGradientBackgroundColor(&cell)
        let category = self.categoriesArray[indexPath.row]
        cell.categoryNameLabel.text = category as? String
        
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(indexPath.row % 3 == NUMBER_ZERO) {
            return CGSize(width:(WIDTH_WINDOW_FRAME - 2), height:WIDTH_WINDOW_FRAME/2)
        }else {
            return CGSize(width:(WIDTH_WINDOW_FRAME/2 - 0.5), height: WIDTH_WINDOW_FRAME/2)
        }
        
        
    }
    
    //MARK:- CollectionView Delegates
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let object = self.categoriesArray[indexPath.row]
            self.categoryDelegate.categorySelected(item: object)
    }
    


}
