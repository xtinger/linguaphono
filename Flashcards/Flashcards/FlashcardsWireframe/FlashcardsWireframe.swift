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
    
    required init() {
 
    }
    
    func present(to window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loadingVC = storyboard.instantiateViewController(withIdentifier: "LoadingVC") as! LoadingVC
        loadingVC.wireframe = self
        
        rootViewController = UINavigationController(rootViewController: loadingVC)
        window.backgroundColor = Styles.Main.backgroundColor
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        let dataServiceV2: IDataService = DataService(dataStore: UserDefaultsDataStore())
        dataServiceV2.prepare { [weak self] in
            if let ws = self {
                let blockGameWireframe = BlockGameWireframe(dataService: dataServiceV2, parentViewController: ws.rootViewController)
                blockGameWireframe.present()
            }
        }
        
    }
}
