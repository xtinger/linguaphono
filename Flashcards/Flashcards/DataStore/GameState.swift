//
//  GameState.swift
//  Flashcards
//
//  Created by Denis Voronov on 04/06/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class GameState: Codable
{
    var currentLessonIndex: Int = 0
    var isSprintMode = false
    
    var languageOriginal: String
    var languageTranslation: String
    var sourcePhrases: Set<StatPhrase>
    var phrasesInGame: [StatPhrase]
    var lastPhraseReverseLanguageModeInEffect: Bool
    
    init(sourcePhrases: Set<StatPhrase>, phrasesInGame: [StatPhrase], languageOriginal: String, languageTranslation: String, lastPhraseReverseLanguageModeInEffect: Bool) {
        self.sourcePhrases = sourcePhrases
        self.phrasesInGame = phrasesInGame
        self.languageOriginal = languageOriginal
        self.languageTranslation = languageTranslation
        self.lastPhraseReverseLanguageModeInEffect = lastPhraseReverseLanguageModeInEffect
    }
}
