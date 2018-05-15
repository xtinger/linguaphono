//
//  GameProtocols.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

protocol IGamePresenter {
    var view: IGameViewInput! {get set}
}

// view
protocol IGameViewInput : class {
    func show(cardView: CardView)
    func flipTo(cardView: CardView, andBack flipBack: Bool)
}

// presenter
protocol IGameViewOutput {
    func viewDidLoad()
    func userDidTouchYes()
    func userDidTouchNo()
    func userDidTouchRepeat()
}


