//
//  GameStartupData.swift
//  Flashcards
//
//  Created by Denis Voronov on 04/06/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class GameStartupData {
    var phraseSet: Set<StatPhrase>
    var languageOriginal: String
    var languageTranslation: String
    
    init(phraseSet: Set<StatPhrase>, languageOriginal: String, languageTranslation: String) {
        self.phraseSet = phraseSet
        self.languageOriginal = languageOriginal
        self.languageTranslation = languageTranslation
    }
}
