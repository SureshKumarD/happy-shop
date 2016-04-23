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
        self.productNameLabel.sizeToFit()
        self.backgroundColor = kWHITE_COLOR;
        
    }

   

}
