//
//  WordSet.swift
//  Flashcards
//
//  Created by Denis Voronov on 17/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

struct Word : Codable {
    let text: String
    let phrases: [Phrase]
}
