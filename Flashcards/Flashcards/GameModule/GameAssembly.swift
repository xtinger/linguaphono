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
        var presenter : IGamePresenter & IGameViewOutput & IGameServiceOutput = GamePresenter(gameService: game, config: config)
        presenter.output = moduleOutput
        game.output = presenter
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "GameVC") as! GameVC
        viewController.config = config
        viewController.output = presenter
        presenter.view = viewController
        self.viewController = viewController
    }
}
