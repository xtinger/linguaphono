//
//  IGameService.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

enum GameInputAction {
    case Yes;
    case No;
    case Repeat
}

protocol IGameService {
    var output: IGameServiceOutput! {get set}
    func readyToPresent()
    func answered(with action: GameInputAction)
}


