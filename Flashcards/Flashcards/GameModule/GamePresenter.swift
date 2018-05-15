//
//  GamePresenter.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class GamePresenter : NSObject, IGamePresenter, IGameViewOutput {
    typealias Completion = ()->()
    
    var gameService : IGameService
    weak var view: IGameViewInput!
    var presentingCard : CardModel?

    var speaker = Speaker()
    
    required init(gameService : IGameService) {
        self.gameService = gameService
        super.init()
    }
    
    func viewDidLoad() {
        gameService.readyToPresent()
    }
    
    func userDidTouchYes() {
        gameService.answered(with: .Known)
    }
    
    func userDidTouchNo() {
        showFlipped {
            
        }
    }
    
    func showFlipped(completion: Completion) {
        if let card = presentingCard {
            
            let cardView = CardView()
            cardView.label.text = card.textRu
            cardView.backColor = Styles.Card.backgroundColorFlipped
            
            view.flipTo(cardView: cardView, andBack: true)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayBeforeRussianSpeech, execute: { [weak self] in
                self?.sayRussian(card: card, completion: {
                    self?.gameService.answered(with: .Unknown)
                })
            })
        }
    }
    
    func userDidTouchRepeat() {
        if let card = presentingCard {
            sayEnglish(card: card)
        }
    }
    
    func sayEnglish(card: CardModel) {
        speaker.say(text: card.textEng, language: .english)
    }
    
    func sayRussian(card: CardModel, completion: Completion?) {
        speaker.say(text: card.textRu, language: .russian, completion: completion)
    }
}

extension GamePresenter : IGameServiceOutput {
    func presentCard(_ card: CardModel) {
        let cardView = CardView()
        cardView.label.text = card.textEng
        cardView.backColor = Styles.Card.backgroundColorNormal
        presentingCard = card
        view.show(cardView: cardView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayBeforeEnglishSpeech, execute: { [weak self] in
            self?.sayEnglish(card: card)
        })
    }
    
    func finish() {
        
    }
}
//
//extension GamePresenter : AVSpeechSynthesizerDelegate {
//    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        if utterance.voice?.language == "en-US" {
//            if let card = presentingCard {
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayBeforeRussiahSpeech, execute: { [weak self] in
//                    self?.sayRussian(card: card)
//                })
//            }
//        }
//    }
//}
