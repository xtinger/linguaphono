//
//  GamePresenter.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation
import AVFoundation

class GamePresenter : NSObject, IGamePresenter, IGameViewOutput {

    var gameService : IGameService
    weak var view: IGameViewInput!
    var presentingCard : CardModel?

    lazy var synthesizer = {return AVSpeechSynthesizer()}()
    
    required init(gameService : IGameService) {
        self.gameService = gameService
        super.init()
        synthesizer.delegate = self
    }
    
    func viewDidLoad() {
        gameService.readyToPresent()
    }
    
    func userDidTouchYes() {
        gameService.answered(with: .Known)
    }
    
    func userDidTouchNo() {
        gameService.answered(with: .Unknown)
    }
    
    func userDidTouchRepeat() {
        if let card = presentingCard {
            sayEnglish(card: card)
        }
    }
    
    func sayEnglish(card: CardModel) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: card.textEng)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
    func sayRussian(card: CardModel) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: card.textRu)
        utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
        synthesizer.speak(utterance)
    }
}

extension GamePresenter : IGameServiceOutput {
    func presentCard(_ card: CardModel) {
        let cardView = CardView()
        cardView.configure(with: card)
        presentingCard = card
        view.showCardView(cardView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayBeforeEnglishSpeech, execute: { [weak self] in
            self?.sayEnglish(card: card)
        })
    }
}

extension GamePresenter : AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if utterance.voice?.language == "en-US" {
            if let card = presentingCard {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + GameConfig.delayBeforeRussiahSpeech, execute: { [weak self] in
                    self?.sayRussian(card: card)
                })
            }
        }
    }
}
