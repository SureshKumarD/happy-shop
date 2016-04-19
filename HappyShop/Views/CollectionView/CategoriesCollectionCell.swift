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
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = kPINK_COLOR.CGColor
        self.contentView.backgroundColor = UIColor.clearColor()
//        self.setGradientBackgroundColor( self.categoryContainerView)
        self.backgroundColor = kSEA_SHELL_COLOR2;
        
    }
    
    //MARK:- Set Background Color
    func setGradientBackgroundColor(view : UIView!) {
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [kSNOW_COLOR.CGColor, kWHITE_COLOR.CGColor, kSNOW_COLOR.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
    }

    

}
