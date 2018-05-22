//
//  FlashcardsStyles.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

struct Styles {
    private struct Colors {
        static let sub = UIColor(hex: 0xE6F2FF)
        static let active = UIColor(hex: 0x83CCFF)
        static let passive = UIColor(hex: 0x24C569)
        static let text = UIColor.gray
        static let control = UIColor.white
    }
    
    struct Main {
        static let backgroundColor = Colors.sub
        static let cornerRadius : CGFloat = 12
    }
    
    struct BigButton {
        static let backgroundColor = Colors.control
        static let textColor = Colors.text
        static let borderColor = Colors.text
    }
    
    struct Card {
        static let backgroundColorNormal = Colors.active
        static let backgroundColorFlipped = Colors.passive
    }
}

