//
//  GameAssembly.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

class GameAssembly {
    var viewController : UIViewController!
    
    required init(gameStartupData: GameStartupData, config: GameConfig, moduleOutput: IGameModuleOutput?) {
        var game : IGameService = PhrasesGameService(gameStartupData: gameStartupData, config: config)
        commonInit(game: &game, config: config, moduleOutput: moduleOutput)
    }
    
    required init(gameState: GameState, config: GameConfig, moduleOutput: IGameModuleOutput?) {
        var game : IGameService = PhrasesGameService(gameState: gameState, config: config)
        commonInit(game: &game, config: config, moduleOutput: moduleOutput)
    }
    
    private func commonInit(game : inout IGameService, config: GameConfig, moduleOutput: IGameModuleOutput?) {
        var presenter : IGamePresenter & IGameViewOutput & IGameServiceOutput = GamePresenter(gameService: game, config: config)
        presenter.output = moduleOutput
        game.output = presenter
        game.dataOutput = UserDefaultsDataStore()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "GameVC") as! GameVC
        viewController.config = config
        viewController.output = presenter
        presenter.view = viewController
        self.viewController = viewController
    }
}
