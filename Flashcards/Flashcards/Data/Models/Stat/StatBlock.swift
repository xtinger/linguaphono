//
//  StatBlock.swift
//  Flashcards
//
//  Created by Denis Voronov on 18/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

struct StatBlock : Codable {
    var lessons: [StatLesson]
    
    init(lessons: [StatLesson]) {
        self.lessons = lessons
    }
}
