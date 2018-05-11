//
//  UIView_Constraints.swift
//  EvergreenBitsUI
//
//  Created by Denis Voronov on 10/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import UIKit

public extension UIView {
    func addFillSuperviewConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict = ["view": self]
        self.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        self.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
    }
}
