//
//  IGameServiceOutput.swift
//  Flashcards
//
//  Created by Denis Voronov on 10/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

protocol IGameServiceOutput {
    func presentPhrase(_ phrasePresentation: PhrasePresentation)
    func updateProgress(_ progress: Float)
    func finish()
}

protocol IGameServiceDataOutput {
    func saveGameState(_ gameState: GameState) throws
}
