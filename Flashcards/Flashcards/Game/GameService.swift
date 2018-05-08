//
//  GameService.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class GameService : IGameService{
    var dataService : IDataService
    
    required init(dataService: IDataService) {
        self.dataService = dataService
    }
}
