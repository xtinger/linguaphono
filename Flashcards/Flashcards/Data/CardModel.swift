//
//  CardModel.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

enum AnswerType {
    case Known, Unknown
}

struct CardModel {
    var id : Int
    var textEng : String
    var textRu : String
    var lastAnswers : [Bool]
    var corrects : Int
    var incorrects : Int
    
    init(id: Int, textEng: String, textRu: String, corrects: Int, incorrects: Int) {
        self.id = id
        self.textEng = textEng
        self.textRu = textRu
        self.corrects = corrects
        self.incorrects = incorrects
        self.lastAnswers = []
    }
}
