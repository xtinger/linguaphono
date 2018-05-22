//
//  StatLesson.swift
//  Flashcards
//
//  Created by Denis Voronov on 18/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

struct StatLesson : Codable {
    var words: [StatWord]
    
    init(words: [StatWord]) {
        self.words = words
    }
}
