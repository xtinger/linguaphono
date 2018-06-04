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
    
    init(lessons: [StatLesson]) {
        self.lessons = lessons
    }
}
