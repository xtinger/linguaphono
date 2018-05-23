//
//  GameProtocols.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

protocol IGamePresenter {
    var view: IGameViewInput! {get set}
    var output: IGameModuleOutput? {get set}
}

// view
protocol IGameViewInput : class {
    typealias FlipCompletion = ()->()
    func show(cardView: CardView, completion:FlipCompletion?)
    func flipTo(cardView: CardView)
    func flipTo(cardView: CardView, completion:FlipCompletion?)
    func userInputEnabled(enabled: Bool)
    func changeProgress(value: Float)
    func alert(alert: UIAlertController, animated: Bool)
}

// presenter
protocol IGameViewOutput {
    func viewDidLoad()
    func userDidTouchCard()
    func userDidTouchYes()
    func userDidTouchNo()
    func userDidTouchRepeat()
    func userDidTouchMenu()
}


