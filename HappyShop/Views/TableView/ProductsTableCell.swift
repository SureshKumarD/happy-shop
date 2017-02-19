//
//  ProductsTableCell.swift
//  HappyShop
//
//  Created by Suresh on 4/18/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit

class ProductsTableCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productAvailabilityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 5.0
        self.containerView.layer.borderColor = UIColor.gray.cgColor
        self.containerView.backgroundColor = kWHITE_COLOR
        self.contentView.backgroundColor = kWHITE_COLOR
        self.productNameLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
