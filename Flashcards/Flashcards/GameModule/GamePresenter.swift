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
    var presentingCard : StatPhrase?
    
    var cardNormal : CardView?
    var cardFlipped : CardView?
    weak var cardCurrent : CardView? // cardNormal or cardFlipped

    var speaker = Speaker()
    
    required init(gameService : IGameService) {
        self.gameService = gameService
        super.init()
    }
    
    func viewDidLoad() {
        gameService.readyToPresent()
    }
    
    func userDidTouchCard() {
        view.userInputEnabled(enabled: false)
        flip()
    }
    
    func userDidTouchYes() {
        view.userInputEnabled(enabled: false)
        gameService.answered(with: .Yes)
    }
    
    func userDidTouchNo() {
        view.userInputEnabled(enabled: false)
        
        if (isOnNormalSide()) {
            guard let presentingCard = presentingCard, let cardFlipped = cardFlipped else {
                return
            }
            
            view.flipTo(cardView: cardFlipped)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayBeforeRussianSpeech, execute: { [weak self] in
                self?.sayRussian(card: presentingCard, completion: {
                    self?.gameService.answered(with: .No)
                })
            })
        }
        else {
            gameService.answered(with: .No)
        }
    }
    
    func isOnNormalSide() -> Bool {
        if let cn = cardNormal, let cc = cardCurrent {
            return cc === cn
        }
        else {
            return false // TODO: precondi
        }
    }
    
    func flip() {
        guard let presentingCard = presentingCard, let cardFlipped = cardFlipped, let cardNormal = cardNormal else {
            return
        }
        
        if isOnNormalSide() {
            view.flipTo(cardView: cardFlipped)
            sayRussian(card: presentingCard) {
                self.view.userInputEnabled(enabled: true)
            }
            cardCurrent = cardFlipped
        }
        else {
            view.flipTo(cardView: cardNormal)
            sayEnglish(card: presentingCard) {
                self.view.userInputEnabled(enabled: true)
            }
            cardCurrent = cardNormal
        }
    }
    
    func userDidTouchRepeat() {
        if let card = presentingCard {
            sayEnglish(card: card)
        }
    }
    
    func sayEnglish(card: StatPhrase, completion: Completion?) {
        speaker.say(text: card.textEng, language: .languageNormal, completion: completion)
    }
    
    func sayEnglish(card: StatPhrase) {
        sayEnglish(card:card, completion: nil)
    }
    
    func sayRussian(card: StatPhrase, completion: Completion?) {
        speaker.say(text: card.textRu, language: .languageBack, completion: completion)
    }
    
    func sayRussian(card: StatPhrase) {
        speaker.say(text: card.textRu, language: .languageBack, completion: nil)
    }
}

extension GamePresenter : IGameServiceOutput {
    func presentCard(_ card: StatPhrase) {
        
        let cardViewNormal = CardView()
        cardViewNormal.label.text = card.textEng
        cardViewNormal.backColor = Styles.Card.backgroundColorNormal
        self.cardNormal = cardViewNormal
        
        let cardViewFlipped = CardView()
        cardViewFlipped.label.text = card.textRu
        cardViewFlipped.backColor = Styles.Card.backgroundColorFlipped
        self.cardFlipped = cardViewFlipped

        presentingCard = card
        
        view.show(cardView: cardViewNormal, completion: nil)
        cardCurrent = cardViewNormal
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayBeforeEnglishSpeech, execute: { [weak self] in
            self?.sayEnglish(card: card) {
                self?.view.userInputEnabled(enabled: true)
            }
        })
    }
    
    func finish() {
        exit(0)
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
