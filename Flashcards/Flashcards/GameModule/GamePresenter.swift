//
//  GamePresenter.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

class GamePresenter : IGamePresenter, IGameViewOutput {
    
    typealias Completion = ()->()
    
    var gameService : IGameService
    weak var view: IGameViewInput!
    var output: IGameModuleOutput?
    var phrasePresentation : PhrasePresentation?
    
    var config: GameConfig!
    
    var cardNormal : CardView?
    var cardFlipped : CardView?
    weak var cardCurrent : CardView? // cardNormal or cardFlipped

    var speaker: Speaker
    
    required init(gameService : IGameService, config: GameConfig) {
        self.gameService = gameService
        self.config = config
        self.speaker = Speaker(config: config)
    }
    
    func viewDidLoad() {
        gameService.readyToPresent()
    }
    
    func userDidTouchMenu() {
        output?.userDidTouchMenu()
    }
    
    func userDidTouchCard() {
        print("userDidTouchCard()")
        view.userInputEnabled(enabled: false)
        flip()
    }
    
    func userDidTouchYes() {
        print("userDidTouchYes()")
        view.userInputEnabled(enabled: false)
        
        let completion : IGameViewInput.FlipCompletion = { [weak self] in
            self?.gameService.answered(with: .Yes)
        }

        if config.showTranslationOnAnyAnswer && isOnNormalSide() {
            guard let phrasePresentation = phrasePresentation, let cardFlipped = cardFlipped else {
                return
            }

            view.flipTo(cardView: cardFlipped) {
                self.completeIfMuted(completion)
            }
            
            if !config.muted {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + config.delayBeforeRussianSpeech, execute: { [weak self] in
                    self?.attemptToSayFlipped(phrasePresentation: phrasePresentation, completion: completion)
                })
            }
        }
        else {
           completion()
        }
    }
    
    func userDidTouchNo() {
        print("userDidTouchNo()")
        view.userInputEnabled(enabled: false)
        
        let completion : IGameViewInput.FlipCompletion = { [weak self] in
            self?.gameService.answered(with: .No)
        }
        
        if (isOnNormalSide()) {
            guard let presentingCard = phrasePresentation, let cardFlipped = cardFlipped else {
                return
            }

            view.flipTo(cardView: cardFlipped) {
                self.completeIfMuted(completion)
            }
            
            if !config.muted {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + config.delayBeforeRussianSpeech, execute: { [weak self] in
                    self?.attemptToSayFlipped(phrasePresentation: presentingCard, completion: completion)
                })
            }
        }
        else {
            completion()
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
        guard let phrasePresentation = phrasePresentation, let cardFlipped = cardFlipped, let cardNormal = cardNormal else {
            return
        }
        
        let completion = {
            self.view.userInputEnabled(enabled: true)
        }
        
        if isOnNormalSide() {
            view.flipTo(cardView: cardFlipped) {
                self.completeIfMuted(completion)
            }
            attemptToSayFlipped(phrasePresentation: phrasePresentation, completion: completion)
            cardCurrent = cardFlipped
        }
        else {
            view.flipTo(cardView: cardNormal) {
                self.completeIfMuted(completion)
            }
            attemptToSayNormal(phrasePresentation: phrasePresentation, completion: completion)
            
            cardCurrent = cardNormal
        }
    }
    
    func userDidTouchRepeat() {
        self.view.userInputEnabled(enabled: false)
        if let presentingCard = phrasePresentation {
            // произносить даже если muted
            speaker.say(text: presentingCard.textNormal, language: config.languageOriginal) {
                self.view.userInputEnabled(enabled: true)
            }
        }
    }
    
    func attemptToSayNormal(phrasePresentation: PhrasePresentation, completion: Completion?) {
        guard !config.muted else {return}
        speaker.say(text: phrasePresentation.textNormal, language: phrasePresentation.languageNormal, completion: completion)
    }
    
    func attemptToSayNormal(phrasePresentation: PhrasePresentation) {
        guard !config.muted else {return}
        attemptToSayNormal(phrasePresentation:phrasePresentation, completion: nil)
    }
    
    func attemptToSayFlipped(phrasePresentation: PhrasePresentation, completion: Completion?) {
        guard !config.muted else {return}
        speaker.say(text: phrasePresentation.textFlipped, language: phrasePresentation.languageFlipped, completion: completion)
    }
    
    func attemptToSayFlipped(phrasePresentation: PhrasePresentation) {
        guard !config.muted else {return}
        attemptToSayFlipped(phrasePresentation: phrasePresentation, completion: nil)
    }
    
    func completeIfMuted(_ completion: @escaping Completion) {
        if config.muted {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + config.delayAfterAnimationIfMuted, execute: {
                completion()
            })
        }
    }
}

extension GamePresenter : IGameServiceOutput {
    func updateProgress(_ progress: Float) {
        view.changeProgress(value: progress)
    }
    
    func presentPhrase(_ phrasePresentation: PhrasePresentation) {
        
        let cardViewNormal = CardView()
        cardViewNormal.label.text = phrasePresentation.textNormal
        cardViewNormal.backColor = Styles.Card.backgroundColorNormal
        self.cardNormal = cardViewNormal
        
        let cardViewFlipped = CardView()
        cardViewFlipped.label.text = phrasePresentation.textFlipped
        cardViewFlipped.backColor = Styles.Card.backgroundColorFlipped
        self.cardFlipped = cardViewFlipped
        
        self.phrasePresentation = phrasePresentation
        
        self.view.userInputEnabled(enabled: false)
        
        let enableUI = {
            self.view.userInputEnabled(enabled: true)
        }
        
        view.show(cardView: cardViewNormal) {
            self.completeIfMuted(enableUI)
        }
        cardCurrent = cardViewNormal
        
        if !config.muted {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + config.delayBeforeEnglishSpeech, execute: { [weak self] in
                if let phrasePresentation = self?.phrasePresentation {
                    self?.attemptToSayNormal(phrasePresentation: phrasePresentation, completion: enableUI)
                }
            })
        }
    }

    func finish() {
        let alert = UIAlertController(title: "Поздравляем!", message: "Вы прошли обучение", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Выйти", style: .default, handler: { [weak self] (action) in
            self?.output?.gameFinished()
        }))
        view.alert(alert: alert, animated: true)
    }
}
