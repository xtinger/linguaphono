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
    var dataService: IDataService
    
    required init(dataService: IDataService) {
        self.dataService = dataService
        guard let currentLesson = self.dataService.currentLesson else {
            print("BlockGameWireframe: currentLesson not found!")
            return
        }
        let gameAssembly = GameAssembly(lesson: currentLesson)
        viewController = gameAssembly.viewController
    }
}
