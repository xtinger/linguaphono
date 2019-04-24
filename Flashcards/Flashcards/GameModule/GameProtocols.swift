//
//  GameProtocols.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

protocol GamePresenterProtocol {
    var view: GameViewInputProtocol! {get set}
    var output: GameModuleOutputProtocol? {get set}
}

protocol GameViewInputProtocol : class {
    typealias FlipCompletion = ()->()
    func show(cardView: CardView, completion:FlipCompletion?)
    func flipTo(cardView: CardView)
    func flipTo(cardView: CardView, completion:FlipCompletion?)
    func userInputEnabled(enabled: Bool)
    func changeProgress(value: Float)
    func alert(alert: UIAlertController, animated: Bool)
}

protocol GameViewOutputProtocol {
    func viewDidLoad()
    func userDidTouchCard()
    func userDidTouchYes()
    func userDidTouchNo()
    func userDidTouchRepeat()
    func userDidTouchMenu()
}

protocol GameModuleOutputProtocol {
    func gameFinished()
    func userDidTouchMenu()
}
