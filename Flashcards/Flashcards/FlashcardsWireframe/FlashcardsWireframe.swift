//
//  FlashcardsWireframe.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

class FlashcardsWireframe {
    
    var rootViewController : UINavigationController!
    var viewController : UIViewController!
    var dataService: IDataService = {
        let dataStore = UserDefaultsDataStore()
        return DataService(dataStore: dataStore)
    }()
    
    func setup(with gameStartupData: GameStartupData, config: GameConfig) {
        let gameAssembly = GameAssembly(gameStartupData: gameStartupData, config: config, moduleOutput: self as GameModuleOutputProtocol)
        self.viewController = gameAssembly.viewController
    }
    
    func setup(with gameState: GameState, config: GameConfig) {
        let gameAssembly = GameAssembly(gameState: gameState, config: config, moduleOutput: self as GameModuleOutputProtocol)
        self.viewController = gameAssembly.viewController
    }
    
    func present(to window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if dataService.isSaved() {
            let ws = self
            dataService.prepare { /*[weak self]*/ (gameState)  in
//                if let ws = self {
                    if let gameState = gameState {
                        ws.setup(with: gameState, config: ws.dataService.config)
                    }
                    else if let gameStartupData = ws.dataService.prepareNextGame() {
                        ws.setup(with: gameStartupData, config: ws.dataService.config)
                    }
                    
                    ws.rootViewController = UINavigationController(rootViewController: ws.viewController)
                    window.backgroundColor = Styles.Main.backgroundColor
                    window.rootViewController = ws.rootViewController
                    window.makeKeyAndVisible()
                    
                    ws.presentGame()
//                }
            }
        }
        else {
            let loadingVC = storyboard.instantiateViewController(withIdentifier: "LoadingVC") as! LoadingVC
            loadingVC.wireframe = self // extend FlashcardsWireframe life
            
            rootViewController = UINavigationController(rootViewController: loadingVC)
            window.backgroundColor = Styles.Main.backgroundColor
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
            
            dataService.prepare { [weak self] (gameState)  in
                if let ws = self {
                    if let gameState = gameState {
                        ws.setup(with: gameState, config: ws.dataService.config)
                    }
                    else if let gameStartupData = ws.dataService.prepareNextGame() {
                        ws.setup(with: gameStartupData, config: ws.dataService.config)
                    }
                    ws.presentGame()
                }
            }
        }
        
        
    }
    
    func presentGame() {
        rootViewController.setViewControllers([viewController], animated: true)
    }
    
    func presentMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        menuVC.config = dataService.config
        menuVC.wireframe = self
        menuVC.navigationItem.title = "Настройки"
        menuVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Готово", style: .plain, target: self, action: #selector(settingsMenuTouched))
        let navMenuVC = UINavigationController(rootViewController: menuVC)
        viewController.present(navMenuVC, animated: true, completion: nil)
    }

    @objc func settingsMenuTouched(sender: UIButton) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func reload() {
        dataService.saveConfig()
        dataService.deleteStat()
        present(to: UIApplication.shared.keyWindow!)
    }
}

extension FlashcardsWireframe : GameModuleOutputProtocol {
    func gameFinished() {
        if let gameStartupData = dataService.prepareNextGame() {
            setup(with: gameStartupData, config: dataService.config)
            presentGame()
        }
        else {
            exit(0)
        }
    }
    
    func userDidTouchMenu() {
        presentMenu()
    }
}
