//
//  GameConfig.swift
//  Flashcards
//
//  Created by Denis Voronov on 11/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class GameConfig : Codable, IGameVCConfig  {

    private enum CodingKeys: String, CodingKey {
        case phrasesURL
        case newLessonPhaseMinQuestionsForeachPhrase
        case maximumSprintAdditionalPhrases
        case delayBeforeEnglishSpeech
        case delayBeforeRussianSpeech
        case cardChangeAnimationDuration
        case delayAfterAnimationIfMuted
        case placeInQueueMaxOffset
        case placeInQueueMinOffset
        case speechRatePresetKey
        case muted
        case showTranslationOnAnyAnswer
        case reverseLanguageMode
    }
    
    static var speechRatePresets: [(String, Float)] = [
        ("1", 0.3),
        ("2", 0.35),
        ("3", 0.4),
        ("4", 0.45),
        ("5", 0.5)
    ]
    
    enum ReverseLanguageMode: Int, Codable {
        case off, random, on
    }
    
    static var reverseLanguageModeSetting: [(String, ReverseLanguageMode)] = [
        ("Выключен", .off),
        ("Случайный", .random),
        ("Постоянный", .on),
    ]
    
    
    // Gennady
//    var phrasesURL: URL? = URL(string: "https://docs.google.com/spreadsheets/d/e/2PACX-1vTw9rj-HGxxsVaHWmqY2Getn7Nw_h1RVlkjLiXZPZdXHmxDEVrXxvQbXWfgOw7sWixSEhEtSQ-jCCt4/pub?gid=0&single=true&output=csv")
    
    // Denis
    var phrasesURL: URL? = URL(string: "https://docs.google.com/spreadsheets/d/e/2PACX-1vTU-6DIkV0r9tpxevoVTPJerk9D7xA0GjY-qdjgASDwXUL0FwHftAXMhXmeUlEDb_wcn4pgfSgNMmx4/pub?gid=0&single=true&output=csv")
    
    
    var newLessonPhaseMinQuestionsForeachPhrase = 1
    var maximumSprintAdditionalPhrases = 10
    var delayBeforeEnglishSpeech = 0.7
    var delayBeforeRussianSpeech = 0.7
    var cardChangeAnimationDuration: TimeInterval = 0.35
    var delayAfterAnimationIfMuted = 0.5
    var placeInQueueMaxOffset = 18
    var placeInQueueMinOffset = 9
    var speechRatePresetKey = "3"
    var muted = false
    var showTranslationOnAnyAnswer = true
    var reverseLanguageMode: ReverseLanguageMode = .off
}
