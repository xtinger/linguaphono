//
//  GameService.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation


class GameService : IGameService {
    
    var output: IGameServiceOutput!

    let config = GameConfig()

    private var dataService : IDataService
    
    var current : CardModel!

    required init(dataService: IDataService) {
        self.dataService = dataService
//        self.createWindowFirstTime()
        
        
    }

    
//    private func createWindowFirstTime() {
//        dataService.windowStart = 0
//        dataService.windowEnd = self.dataService.windowStart + GameService.WindowLength
//        dataService.currentCard = self.dataService.allCards[self.dataService.windowStart]
//    }
    
    func readyToPresent() {
        self.dataService.prepare { [unowned self] in
            //            if self.dataService.currentCard == nil {
            //                self.createWindowFirstTime()
        }
        current = dataService.cards.first!
        output.presentCard(current)
        //        }
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
        current = dataService.cards[index]
        output.presentCard(current)
    }
    
    

}


