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
        self.backgroundColor = kCLEAR_COLOR;
        
    }
    
    //MARK:- Set Background Color
    func setGradientBackgroundColor(view : UIView!) {
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [kSNOW_COLOR.CGColor, kWHITE_COLOR.CGColor, kSNOW_COLOR.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
    }

    

}
