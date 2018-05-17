//
//  GameService.swift
//  Flashcards
//
//  Created by Denis Voronov on 14/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class GameService : IGameService {
    private var dataService : IDataService
    let config = GameConfig()
    
    var output: IGameServiceOutput!
    
    var past : [CardModel] = []
    var current : CardModel!
    var future : [CardModel] = []

    required init(dataService: IDataService) {
        self.dataService = dataService
    }
    
    func readyToPresent() {
        dataService.prepare {
            
        }
        
        
    }
    
    func answered(with action: GameInputAction) {
        
    }
    
    
}
