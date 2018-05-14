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
    
    required init() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var game : IGameService = SimpleGameService(dataService: TestingDataService())
        var presenter : IGamePresenter & IGameViewOutput & IGameServiceOutput = GamePresenter(gameService: game)
        game.output = presenter
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "GameVC") as! GameVC
        viewController.output = presenter
        presenter.view = viewController
        self.viewController = viewController
    }
}
