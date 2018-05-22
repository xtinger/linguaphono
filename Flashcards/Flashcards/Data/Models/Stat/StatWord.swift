//
//  StatWord.swift
//  Flashcards
//
//  Created by Denis Voronov on 18/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class StatWord : Codable {
    var text: String
    var phrases: [StatPhrase]
    
    init(text: String, phrases: [StatPhrase]) {
        self.text = text
        self.phrases = phrases
    }
}
