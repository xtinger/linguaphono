//
//  FlashcardsStyles.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

struct Styles {
    struct Main {
        static let backgroundColor = UIColor(hex: 0xE6F2FF)
        static let cornerRadius : CGFloat = 12
    }
    
    struct BigButton {
        static let backgroundColor = UIColor.white
        static let textColor = UIColor.gray
        static let borderColor = UIColor.gray
    }
    
    struct Card {
        static let backgroundColorNormal = UIColor(hex: 0x83CCFF)
        static let backgroundColorFlipped = UIColor.green
    }
}

