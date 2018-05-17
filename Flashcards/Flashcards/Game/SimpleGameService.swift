//
//  GameService.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class SimpleGameService : IGameService {
    
    var output: IGameServiceOutput!

    let config = GameConfig()

    private var dataService : IDataService
    
    var current : CardModel!

    required init(dataService: IDataService) {
        self.dataService = dataService
    }

    func readyToPresent() {
        self.dataService.prepare {
            self.current = self.dataService.cards.first!
            self.output.presentCard(self.current)
        }
    }

    func answered(with action: GameInputAction) {
        
        switch action {
        case .Yes:
            current.corrects += 1
        case .No:
            current.incorrects += 1
        case .Repeat:
            break
        }
        
        dataService.currentCardIndex += 1
        let index = dataService.currentCardIndex
        if index < dataService.cards.count {
            current = dataService.cards[index]
            output.presentCard(current)
        }
        else {
            output.finish()
        }
    }
}


