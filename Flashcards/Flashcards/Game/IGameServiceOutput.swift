//
//  IGameServiceOutput.swift
//  Flashcards
//
//  Created by Denis Voronov on 10/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

protocol IGameServiceOutput {
    func presentCard(_ card: StatPhrase)
    func updateProgress(_ progress: Float)
    func finish()
}
