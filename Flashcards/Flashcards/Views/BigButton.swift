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
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.layer.borderWidth = 0
        self.layer.cornerRadius = Styles.Main.cornerRadius
        self.backgroundColor = Styles.BigButton.backgroundColor
        self.setTitleColor(Styles.BigButton.textColor, for: .normal)
        self.layer.borderColor = Styles.BigButton.borderColor.cgColor
    }
    
}
