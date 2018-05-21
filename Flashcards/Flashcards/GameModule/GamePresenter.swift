//
//  GamePresenter.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

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
            
            let completion : IGameViewInput.FlipCompletion = { [weak self] in
                self?.gameService.answered(with: .No)
            }
            
            view.flipTo(cardView: cardFlipped) {
                if GameConfig.muted {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayAfterAnimationIfMuted, execute: {
                        completion()
                    })
                }
            }
            
            if !GameConfig.muted {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayBeforeRussianSpeech, execute: { [weak self] in
                    self?.sayRussian(card: presentingCard, completion: completion)
                })
            }
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
        
        let completion = {
            self.view.userInputEnabled(enabled: true)
        }
        
        if isOnNormalSide() {
            view.flipTo(cardView: cardFlipped) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayAfterAnimationIfMuted, execute: {
                    completion()
                })
            }
            if !GameConfig.muted {
                sayRussian(card: presentingCard) {
                    completion()
                }
            }
            cardCurrent = cardFlipped
        }
        else {
            view.flipTo(cardView: cardNormal) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayAfterAnimationIfMuted, execute: {
                    completion()
                })
            }
            if !GameConfig.muted {
                sayEnglish(card: presentingCard) {
                    completion()
                }
            }
            
            cardCurrent = cardNormal
        }
    }
    
    func userDidTouchRepeat() {
        self.view.userInputEnabled(enabled: false)
        if let card = presentingCard {
            sayEnglish(card: card) {
                self.view.userInputEnabled(enabled: true)
            }
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
    func updateProgress(_ progress: Float) {
        view.changeProgress(value: progress)
    }
    
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
        
        let completion = {
            self.view.userInputEnabled(enabled: true)
        }
        
        view.show(cardView: cardViewNormal) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayAfterAnimationIfMuted, execute: {
                completion()
            })
        }
        cardCurrent = cardViewNormal
        
        if !GameConfig.muted {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayBeforeEnglishSpeech, execute: { [weak self] in
                self?.sayEnglish(card: card) {
                    completion()
                }
            })
        }
    }
    
    func finish() {
        let alert = UIAlertController(title: "Поздравляем!", message: "Вы прошли обучение", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Выйти", style: .default, handler: {(action) in
            exit(0)
            
        }))
        view.alert(alert: alert, animated: true)
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
