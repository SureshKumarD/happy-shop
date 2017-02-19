//
//  UIAlertView+Custom.swift
//  ImageGallery
//
//  Created by Suresh on 4/13/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertView  {
    public func closAlertAfterDelay(delayInSeconds : TimeInterval) {
        self.perform(Selector("closeAlertView"), with: nil, afterDelay: delayInSeconds)
       
    }
    
    public func closeAlertView() {
        self.dismiss(withClickedButtonIndex: 0, animated: true)
    }

}
