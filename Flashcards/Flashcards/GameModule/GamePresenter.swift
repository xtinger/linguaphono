//
//  GamePresenter.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class GamePresenter : IGameViewOutput {

    var gameService : IGameService
    
    required init(gameService : IGameService) {
        self.gameService = gameService
    }
    
    func viewDidLoad() {
        
    }
    
    func userDidTouchYes() {
        
    }
    
    func userDidTouchNo() {
        
    }
    
    func userDidTouchRepeat() {
        
    }
 
}
