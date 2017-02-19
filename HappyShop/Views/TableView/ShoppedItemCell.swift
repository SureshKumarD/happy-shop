//
//  ShoppedItemCell.swift
//  HappyShop
//
//  Created by Suresh on 4/22/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit

class ShoppedItemCell: UITableViewCell {
    
    //Interface outlets...
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productRemoveButton: UIButton!
    
    
    @IBOutlet weak var quantityCountButton: UIButton!
    var removeItemDelegate : SelectedItemDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.productImageView.layer.masksToBounds = true
        self.productImageView.layer.borderColor = kGRAY_COLOR2.cgColor
        self.productImageView.layer.borderWidth = 0.5
        self.productImageView.layer.cornerRadius = 5.0
        self.quantityCountButton.layer.masksToBounds = true
        self.quantityCountButton.layer.borderColor = kGRAY_COLOR2.cgColor
        self.quantityCountButton.layer.borderWidth = 0.5
        self.quantityCountButton.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func productRemoveButtonTapped(sender: AnyObject) {
        
        self.removeItemDelegate.removeItemAtIndex(index:sender.tag)
    }
    
    
    @IBAction func quantityButtonTapped(sender: AnyObject) {
        
        self.removeItemDelegate.quantityButtonTappedAt(index:sender.tag)
    }

}
