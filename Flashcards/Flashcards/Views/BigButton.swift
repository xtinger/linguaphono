//
//  BigButton.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

@IBDesignable
class BigButton : UIButton {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor.white
        self.setTitleColor(UIColor.darkGray, for: .normal)
        self.layer.borderColor = UIColor.black.cgColor
    }
}
