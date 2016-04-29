//
//  QuantityCell.swift
//  HappyShop
//
//  Created by Suresh on 4/29/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit

class QuantityCell: UITableViewCell {

    @IBOutlet weak var quantityCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.quantityCountLabel.layer.borderColor = kBLACK_COLOR.CGColor
        self.quantityCountLabel.layer.borderWidth = 1.0
        self.quantityCountLabel.layer.cornerRadius = 5.0
        self.quantityCountLabel.layer.masksToBounds = true
        self.quantityCountLabel.backgroundColor = kWHITE_COLOR
        self.backgroundColor = kCLEAR_COLOR
        self.contentView.backgroundColor = kCLEAR_COLOR
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
