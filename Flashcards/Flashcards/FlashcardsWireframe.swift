//
//  FlashcardsWireframe.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

class FlashcardsWireframe {
    var rootViewController : UIViewController!
    
    required init() {
        let gameAssembly = GameAssembly()
        rootViewController = gameAssembly.viewController
    }
    
    func present(to window: UIWindow) {
        window.backgroundColor = Styles.main.backgroundColor
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
