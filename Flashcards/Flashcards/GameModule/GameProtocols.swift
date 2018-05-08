//
//  GameProtocols.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

// view
protocol IGameViewInput {
    
}

// presenter
protocol IGameViewOutput {
    func viewDidLoad()
    func userDidTouchYes()
    func userDidTouchNo()
    func userDidTouchRepeat()
}


