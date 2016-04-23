//
//  CategoriesCollectionCell.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit

class CategoriesCollectionCell: UICollectionViewCell {

    @IBOutlet weak var categoryContainerView: UIView!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = kGRAY_COLOR2.CGColor
        self.layer.borderWidth = 0.5
        self.contentView.backgroundColor = UIColor.clearColor()
        
        //Set light gradient background color on cell...
        DataManager.sharedDataManager().setGradientBackgroundColor(self)
    }
    
    
}
