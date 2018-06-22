//
//  StatRoot.swift
//  Flashcards
//
//  Created by Denis Voronov on 18/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class StatRoot : Codable {
    var blocks: [StatBlock]
    
    var currentBlockIndex: Int
    var currentLessonIndex: Int
    
    init(blocks: [StatBlock]) {
        self.blocks = blocks
        self.currentBlockIndex = -1
        self.currentLessonIndex = -1
    }
}
