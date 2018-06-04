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
    var dataService: IDataService!
    
    func setup(with phrases: Set<StatPhrase>, config: GameConfig) {
        let gameAssembly = GameAssembly(phrases: phrases, config: config, moduleOutput: self as IGameModuleOutput)
        self.viewController = gameAssembly.viewController
    }
    
    func present(to window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loadingVC = storyboard.instantiateViewController(withIdentifier: "LoadingVC") as! LoadingVC
        loadingVC.wireframe = self // extend FlashcardsWireframe life
        
        rootViewController = UINavigationController(rootViewController: loadingVC)
        window.backgroundColor = Styles.Main.backgroundColor
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        let dataStore = UserDefaultsDataStore()
        dataService = DataService(dataStore: dataStore)
        dataService.prepare { [weak self] in
            
            if let ws = self {
                let phrases = ws.dataService.prepareNextPhraseSet()
                if phrases.count > 0 {
                    ws.setup(with: phrases, config: ws.dataService.config)
                }
                
                ws.presentGame()
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
//        rootViewController.setViewControllers([MenuVC], animated: true)
    }

    @objc func settingsMenuTouched(sender: UIButton) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func reload() {
        let dataStore = UserDefaultsDataStore()
        dataStore.deleteStat()
        present(to: UIApplication.shared.keyWindow!)
    }

}

extension FlashcardsWireframe : IGameModuleOutput {
    func gameFinished() {
        let phrases = dataService.prepareNextPhraseSet()
        if phrases.count > 0 {
            setup(with: phrases, config: dataService.config)
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
