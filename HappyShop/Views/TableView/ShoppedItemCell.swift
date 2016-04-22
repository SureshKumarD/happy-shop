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
    
    
    var removeItemDelegate : SelectedItemDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.productImageView.layer.masksToBounds = true
        self.productImageView.layer.borderColor = kGRAY_COLOR2.CGColor
        self.productImageView.layer.borderWidth = 0.5
        self.productImageView.layer.cornerRadius = 5.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func productRemoveButtonTapped(sender: AnyObject) {
        
        self.removeItemDelegate.removeItemAtIndex(sender.tag)
    }
    
    

}
