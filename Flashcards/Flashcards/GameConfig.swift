//
//  GameConfig.swift
//  Flashcards
//
//  Created by Denis Voronov on 11/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

struct GameConfig {
    static var phrasesURL: URL? = URL(string: "https://docs.google.com/spreadsheets/d/e/2PACX-1vTw9rj-HGxxsVaHWmqY2Getn7Nw_h1RVlkjLiXZPZdXHmxDEVrXxvQbXWfgOw7sWixSEhEtSQ-jCCt4/pub?gid=0&single=true&output=csv")
    static var newLessonPhaseMinQuestionsForeachPhrase = 1
    static var maximumSprintAdditionalPhrases = 10
    static var delayBeforeEnglishSpeech = 0.7
    static var delayBeforeRussianSpeech = 0.7
    static var cardChangeAnimationDuration = 0.35
    static var delayAfterAnimationIfMuted = 0.5
    static var placeInQueueMaxOffset = 6
    static var placeInQueueMinOffset = 2
    static var muted = true
    static var languageOriginal = "fr-FR"
    static var languageTranslation = "ru-RU"
}
