//
//  ProductsCollectionCell.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit

class ProductsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productAvailabilityLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 5.0
////        self.layer.borderColor = kPINK_COLOR.CGColor
//        self.contentView.backgroundColor = kWHITE_COLOR
        //        self.setGradientBackgroundColor( self.categoryContainerView)
        self.productNameLabel.sizeToFit()
        self.backgroundColor = kWHITE_COLOR;
        
    }

   

}
