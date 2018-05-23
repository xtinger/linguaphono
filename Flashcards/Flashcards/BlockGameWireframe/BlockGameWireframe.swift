//
//  BlockGameWireframe.swift
//  Flashcards
//
//  Created by Denis Voronov on 22/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

class BlockGameWireframe {
    var viewController : UIViewController!
    var parentViewController : UINavigationController
    var dataService: IDataService
    
    required init(dataService: IDataService, parentViewController : UINavigationController) {
        self.dataService = dataService
        self.parentViewController = parentViewController
        let phrases = dataService.prepareNextPhraseSet()
        if phrases.count > 0 {
            setup(with: phrases)
        }
    }
    
    func setup(with phrases: Set<StatPhrase>) {
        let gameAssembly = GameAssembly(phrases: phrases, moduleOutput: self as IGameModuleOutput)
        self.viewController = gameAssembly.viewController
    }
    
    func present() {
        parentViewController.setViewControllers([viewController], animated: true)
    }
}


extension BlockGameWireframe : IGameModuleOutput {
    func finish() {
        let phrases = dataService.prepareNextPhraseSet()
        if phrases.count > 0 {
            setup(with: phrases)
            present()
        }
        else {
            exit(0)
        }
        
    }
}
