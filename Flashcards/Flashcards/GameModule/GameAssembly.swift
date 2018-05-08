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
        let game : IGameService = GameService(dataService: DataService())
        let presenter : IGameViewOutput = GamePresenter(gameService: game)
        let viewController = storyboard.instantiateViewController(withIdentifier: "GameVC") as! GameVC
        viewController.output = presenter
        self.viewController = viewController
    }
}
