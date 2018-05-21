//
//  StatPhrase.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

enum AnswerType : Int, Codable{
    case Known = 0, Unknown
}

struct StatPhrase: Codable, Equatable, Hashable {

    var textEng : String
    var textRu : String
    var lastAnswers : [AnswerType]
    var corrects : Int
    var incorrects : Int
    
    var hashValue: Int {
        return textEng.hashValue ^ textRu.hashValue
    }
    
    init(textEng: String, textRu: String, corrects: Int, incorrects: Int) {
        self.textEng = textEng
        self.textRu = textRu
        self.corrects = corrects
        self.incorrects = incorrects
        self.lastAnswers = []
    }
}

extension StatPhrase: CustomStringConvertible, CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(textEng) : \(textRu) [\(corrects):\(incorrects)]\n"
    }
    
    var description: String {
        return "\(textEng) : \(textRu) [\(corrects):\(incorrects)]\n"
    }
}
