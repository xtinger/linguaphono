//
//  GamePresenter.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation
import AVFoundation

class GamePresenter : IGamePresenter, IGameViewOutput {

    var gameService : IGameService
    weak var view: IGameViewInput!
    var presentingCard : CardModel?
    
    required init(gameService : IGameService) {
        self.gameService = gameService
    }
    
    func viewDidLoad() {
        gameService.readyToPresent()
    }
    
    func userDidTouchYes() {
        gameService.answered(with: .Yes)
    }
    
    func userDidTouchNo() {
        gameService.answered(with: .No)
    }
    
    func userDidTouchRepeat() {
        if let card = presentingCard {
            say(card: card)
        }
    }
    
    func say(card: CardModel) {
        let utterance = AVSpeechUtterance(string: card.textEng)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

extension GamePresenter : IGameServiceOutput {
    func presentCard(_ card: CardModel) {
        let cardView = CardView()
        cardView.configure(with: card)
        presentingCard = card
        view.showCardView(cardView)
        say(card: card)
    }
}
