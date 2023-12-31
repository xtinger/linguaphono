//
//  GameService.swift
//  Flashcards
//
//  Created by Denis Voronov on 14/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class PhrasesGameService : IGameService {

    var config: GameConfig
    var output: IGameServiceOutput!
    var dataOutput: IGameServiceDataOutput!
    
    var sourcePhrases : Set<StatPhrase> = []
    var phrasesInGame : [StatPhrase]!
    
    var currentPhrase : StatPhrase? {
        get {
            return phrasesInGame.first
        }
    }
    
    var languageOriginal: String
    var languageTranslation: String
    
    var needToRestoreLanguageMode = false
    var lastPhraseReverseLanguageModeInEffect: Bool = false

    required init(gameStartupData: GameStartupData, config: GameConfig) {
        self.sourcePhrases = gameStartupData.phraseSet
        self.config = config
        self.languageOriginal = gameStartupData.languageOriginal
        self.languageTranslation = gameStartupData.languageTranslation
        
        duplicatePhrases()
        shufflePhrases()
    }
    
    required init(gameState: GameState, config: GameConfig) {
//        self.sourcePhrases = gameStartupData.phraseSet
        self.config = config
        self.sourcePhrases = gameState.sourcePhrases
        self.phrasesInGame = gameState.phrasesInGame
        self.languageOriginal = gameState.languageOriginal
        self.languageTranslation = gameState.languageTranslation
        
        self.lastPhraseReverseLanguageModeInEffect = gameState.lastPhraseReverseLanguageModeInEffect
        self.needToRestoreLanguageMode = true
    }
    
    func saveState() {
        let gameState = GameState(sourcePhrases: sourcePhrases, phrasesInGame: phrasesInGame, languageOriginal: languageOriginal, languageTranslation: languageTranslation, lastPhraseReverseLanguageModeInEffect: lastPhraseReverseLanguageModeInEffect)
        try! dataOutput.saveGameState(gameState)
    }
    
    func readyToPresent() {
        
        presentPhrase()
    }

    func buildPhrasePresentation(phrase: StatPhrase) -> PhrasePresentation {
        var reverseLanguageInEffect = config.reverseLanguageMode == .on || arc4random_uniform(2) == 1
        
        if needToRestoreLanguageMode {
            reverseLanguageInEffect = lastPhraseReverseLanguageModeInEffect
            needToRestoreLanguageMode = false
        }
        
        let languageNormal = reverseLanguageInEffect ? languageTranslation : languageOriginal
        let languageFlipped = reverseLanguageInEffect ? languageOriginal : languageTranslation
        let textNormal = reverseLanguageInEffect ? phrase.textTranslated : phrase.textOriginal
        let textFlipped = reverseLanguageInEffect ? phrase.textOriginal : phrase.textTranslated
        let settings = PhrasePresentation(languageNormal: languageNormal, languageFlipped: languageFlipped, textNormal: textNormal, textFlipped: textFlipped, reverseLanguageInEffect: reverseLanguageInEffect)
        
        lastPhraseReverseLanguageModeInEffect = reverseLanguageInEffect
        
        return settings
    }
    
    func presentPhrase() {
        if let currentPhrase = currentPhrase {
            let phrasePresentation = buildPhrasePresentation(phrase: currentPhrase)
            lastPhraseReverseLanguageModeInEffect = phrasePresentation.reverseLanguageInEffect
            output.presentPhrase(phrasePresentation)
        }
        
        let total: Float = Float(config.newLessonPhaseMinQuestionsForeachPhrase * sourcePhrases.count)
        let progressValue: Float = (total - Float(phrasesInGame.count)) / total
        output.updateProgress(progressValue)
    }
    
    func duplicatePhrases() {
        let phrases1piece = Array(sourcePhrases)
        var result = [StatPhrase]()
        for _ in 1...config.newLessonPhaseMinQuestionsForeachPhrase {
            result += phrases1piece
        }
        self.phrasesInGame = result
    }
    
    func shufflePhrases() {
        var result :[StatPhrase] = phrasesInGame
        
        for i in 0..<result.count where result.count > 0 {
            let swapping = result[i]
            result.remove(at: i)
            let other = Int(arc4random() % UInt32(result.count))
            result.insert(swapping, at: other)
        }
        
        // проверка на отсутствие идущих подряд одинаковых значений
        for i in 1..<result.count where result.count > 0 {
            while(result[i] == result[i - 1]) {
                var other: Int
                repeat {
                    other = Int(arc4random() % UInt32(result.count))
                } while (other != i && result[i] != result[i - 1] && result[i] != result[i + 1])
                let swapping = result[i]
                result.remove(at: i)
                result.insert(swapping, at: other)
            }
        }
        
        self.phrasesInGame = result
    }

    func answered(with action: GameInputAction) {
        
        guard let currentPhrase = self.currentPhrase else {
            fatalError("currentPhrase not set!")
        }
        
        switch action {
        case .Yes:
            currentPhrase.corrects += 1
            removePhraseFromGame()
        case .No:
            currentPhrase.incorrects += 1
            putPhraseBackInGame()
        case .Repeat:
            break
        }

        if let _ = self.currentPhrase {
            presentPhrase()
        }
        else {
            output.updateProgress(1.0)
            output.finish()
        }
    }
    
    @discardableResult
    func removePhraseFromGame() -> StatPhrase{
        return phrasesInGame.remove(at: 0)
    }
    
    func putPhraseBackInGame() {
        guard let currentPhrase = self.currentPhrase else {
            return
        }
        
        let answeredCard = removePhraseFromGame()
        
        let whereToInsert = phrasesInGame.prefix(config.placeInQueueMaxOffset)
        guard !whereToInsert.contains(currentPhrase) else {
            return
        }

        let indexToInsert = config.placeInQueueMaxOffset + Int(arc4random() % UInt32(config.placeInQueueMaxOffset - config.placeInQueueMinOffset))

        while phrasesInGame.count < indexToInsert {
            // множество фразы для вставки
            let uniquePhrasesThatInGame = Set<StatPhrase>(phrasesInGame!)
            
            let phrasesAvailableToInsert = Array(sourcePhrases.filter{!uniquePhrasesThatInGame.contains($0) && $0 != answeredCard})
            let randomIndex = Int(arc4random_uniform(UInt32(phrasesAvailableToInsert.count)))
            let randomPhraseToInsert = phrasesAvailableToInsert[randomIndex]
            phrasesInGame.append(randomPhraseToInsert)
//            uniquePhrasesToInsert.remove(randomPhraseThatNotInGame)
        }
        
        phrasesInGame.insert(answeredCard, at: indexToInsert)
    }
    
}
