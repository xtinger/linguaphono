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
        setupWithCurrentLesson()
    }
    
    func setupWithCurrentLesson() {
        guard let currentLesson = self.dataService.currentLesson else {
            print("BlockGameWireframe: currentLesson not found!")
            return
        }
        let gameAssembly = GameAssembly(lesson: currentLesson, moduleOutput: self as IGameModuleOutput)
        self.viewController = gameAssembly.viewController
    }
    
    func present() {
        parentViewController.setViewControllers([viewController], animated: true)
    }
}


extension BlockGameWireframe : IGameModuleOutput {
    func finish() {
        if dataService.nextLesson() {
            setupWithCurrentLesson()
            present()
        }
        else {
            exit(0)
        }
        
    }
}
