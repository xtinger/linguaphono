//
//  GameConfig.swift
//  Flashcards
//
//  Created by Denis Voronov on 11/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class GameConfig {
    static var speechRatePresets: [(String, Float)] = [
        ("1", 0.3),
        ("2", 0.35),
        ("3", 0.4),
        ("4", 0.45),
        ("5", 0.5)
    ]
    
    enum ReverseLanguageMode {
        case off, random, on
    }
    
    static var reverseLanguageModeSetting: [(String, ReverseLanguageMode)] = [
        ("Выключен", .off),
        ("Случайный", .random),
        ("Постоянный", .on),
    ]
    
    static var phrasesURL: URL? = URL(string: "https://docs.google.com/spreadsheets/d/e/2PACX-1vTw9rj-HGxxsVaHWmqY2Getn7Nw_h1RVlkjLiXZPZdXHmxDEVrXxvQbXWfgOw7sWixSEhEtSQ-jCCt4/pub?gid=0&single=true&output=csv")
    static var newLessonPhaseMinQuestionsForeachPhrase = 1
    static var maximumSprintAdditionalPhrases = 10
    static var delayBeforeEnglishSpeech = 0.7
    static var delayBeforeRussianSpeech = 0.7
    static var cardChangeAnimationDuration = 0.35
    static var delayAfterAnimationIfMuted = 0.5
    static var placeInQueueMaxOffset = 6
    static var placeInQueueMinOffset = 2
    static var speechRatePresetKey = "3"
    static var muted = false
    static var showTranslationOnAnyAnswer = true
    static var languageOriginal = "en-US"
    static var languageTranslation = "ru-RU"
    static var reverseLanguageMode: ReverseLanguageMode = .off
}
