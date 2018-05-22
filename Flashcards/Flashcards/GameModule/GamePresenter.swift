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
        print("userDidTouchCard()")
        view.userInputEnabled(enabled: false)
        flip()
    }
    
    func userDidTouchYes() {
        print("userDidTouchYes()")
        view.userInputEnabled(enabled: false)
        gameService.answered(with: .Yes)
    }
    
    func userDidTouchNo() {
        print("userDidTouchNo()")
        view.userInputEnabled(enabled: false)
        
        if (isOnNormalSide()) {
            guard let presentingCard = presentingCard, let cardFlipped = cardFlipped else {
                return
            }
            
            let completion : IGameViewInput.FlipCompletion = { [weak self] in
                self?.gameService.answered(with: .No)
            }
            
            view.flipTo(cardView: cardFlipped) {
                self.completeIfMuted(completion)
            }
            
            if !GameConfig.muted {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayBeforeRussianSpeech, execute: { [weak self] in
                    self?.attemptToSayRussian(card: presentingCard, completion: completion)
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
                self.completeIfMuted(completion)
            }
            attemptToSayRussian(card: presentingCard, completion: completion)
            cardCurrent = cardFlipped
        }
        else {
            view.flipTo(cardView: cardNormal) {
                self.completeIfMuted(completion)
            }
            attemptToSayEnglish(card: presentingCard, completion: completion)
            
            cardCurrent = cardNormal
        }
    }
    
    func userDidTouchRepeat() {
        self.view.userInputEnabled(enabled: false)
        if let card = presentingCard {
            attemptToSayEnglish(card: card) {
                self.view.userInputEnabled(enabled: true)
            }
        }
    }
    
    func attemptToSayEnglish(card: StatPhrase, completion: Completion?) {
        guard !GameConfig.muted else {return}
        speaker.say(text: card.textEng, language: .languageNormal, completion: completion)
    }
    
    func attemptToSayEnglish(card: StatPhrase) {
        guard !GameConfig.muted else {return}
        attemptToSayEnglish(card:card, completion: nil)
    }
    
    func attemptToSayRussian(card: StatPhrase, completion: Completion?) {
        guard !GameConfig.muted else {return}
        speaker.say(text: card.textRu, language: .languageBack, completion: completion)
    }
    
    func attemptToSayRussian(card: StatPhrase) {
        guard !GameConfig.muted else {return}
        speaker.say(text: card.textRu, language: .languageBack, completion: nil)
    }
    
    func completeIfMuted(_ completion: @escaping Completion) {
        if GameConfig.muted {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayAfterAnimationIfMuted, execute: {
                completion()
            })
        }
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
        
        self.view.userInputEnabled(enabled: false)
        
        let enableUI = {
            self.view.userInputEnabled(enabled: true)
        }
        
        view.show(cardView: cardViewNormal) {
            self.completeIfMuted(enableUI)
        }
        cardCurrent = cardViewNormal
        
        if !GameConfig.muted {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayBeforeEnglishSpeech, execute: { [weak self] in
                self?.attemptToSayEnglish(card: card, completion: enableUI)
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
