//
//  HomeViewController.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, CategoryDelegate {
    
    
    
    //CollectionView...
    private var categoriesCollectionView : CategoriesCollectionView!
    private var flowLayout : UICollectionViewFlowLayout!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationTitle("HappyShop")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- METHODS
    
    
    private func initializations() {
        self.collectionViewDefaultSettings()
        self.registerAllNibs()
        
    }
    //CollectionView initial settings...
    private func collectionViewDefaultSettings() {
        //CollectionView...
        self.flowLayout  = UICollectionViewFlowLayout()
        self.flowLayout.minimumInteritemSpacing = 0.5
        self.flowLayout.minimumLineSpacing = 1
        
        self.categoriesCollectionView = CategoriesCollectionView(frame: self.view.bounds , collectionViewLayout: flowLayout)
        self.categoriesCollectionView.backgroundColor = kCLEAR_COLOR
        self.categoriesCollectionView.categoryDelegate = self
        self.view.addSubview(self.categoriesCollectionView)
        
    }
    
    //Register CollectionView Nib
    private func registerAllNibs() {
        
        self.categoriesCollectionView.registerNib(UINib.init(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier:"CategoriesCollectionCell")
        
    }


    
    //Handler when view did finish layout...
    override func didFinishLayout() {
        self.categoriesCollectionView.frame = self.view.bounds
        
    }

    
    
    
    //MARK:- Category Delegate
    func categorySelected(item: AnyObject!) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let productsVC = storyBoard.instantiateViewControllerWithIdentifier("ProductsViewController") as! ProductsViewController
        DataManager.sharedDataManager().selectedProductCategory =  item as! String!
        
        self.navigationController?.pushViewController(productsVC, animated: false)
        
    }


}

