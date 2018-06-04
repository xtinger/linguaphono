//
//  StatBlock.swift
//  Flashcards
//
//  Created by Denis Voronov on 18/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class StatBlock : Codable {
    var id: Int = 1 // пока только один блок
    
    var lessons: [StatLesson]
    var languageOriginal: String
    var languageTranslation: String
    
    init(lessons: [StatLesson], languageOriginal: String, languageTranslation: String) {
        self.lessons = lessons
        self.languageOriginal = languageOriginal
        self.languageTranslation = languageTranslation
    }
}
