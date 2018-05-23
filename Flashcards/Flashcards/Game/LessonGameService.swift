//
//  GameService.swift
//  Flashcards
//
//  Created by Denis Voronov on 14/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class LessonGameService : IGameService {

    private var dataService : IDataService!
    let config = GameConfig()
    var output: IGameServiceOutput!
    
    var lesson: StatLesson

    var sourcePhrases : Set<StatPhrase> = []
    var phrasesInGame : [StatPhrase]!
    var currentPhrase : StatPhrase? {
        get {
            return phrasesInGame.first
        }
    }

    required init(lesson: StatLesson) {
        self.lesson = lesson
        phrasesInGame = lesson.words.flatMap{return $0.phrases}
        sourcePhrases = Set<StatPhrase>(phrasesInGame)
    }
    
    func readyToPresent() {
        duplicatePhrases()
        shufflePhrases()
        presentPhrase()
    }

    func presentPhrase() {
        if let currentPhrase = currentPhrase {
//            print("\n\n\(phrasesInGame!)")
            output.presentCard(currentPhrase)
        }
        
        let total: Float = Float(GameConfig.newLessonPhaseMinQuestionsForeachPhrase * sourcePhrases.count)
        let progressValue: Float = (total - Float(phrasesInGame.count)) / total
        output.updateProgress(progressValue)
    }
    
    func duplicatePhrases() {
        let phrases1piece = phrasesInGame!
        var result = [StatPhrase]()
        for _ in 1...GameConfig.newLessonPhaseMinQuestionsForeachPhrase {
            result += phrases1piece
        }
        self.phrasesInGame = result
    }
    
    func shufflePhrases() {
        var result :[StatPhrase] = phrasesInGame
        
        for i in 0..<result.count {
            let swapping = result[i]
            result.remove(at: i)
            let other = Int(arc4random() % UInt32(result.count))
            result.insert(swapping, at: other)
        }
        
        // проверка на отсутствие идущих подряд одинаковых значений
        for i in 1..<result.count {
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
            return
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
        
        let whereToInsert = phrasesInGame.prefix(GameConfig.placeInQueueMaxOffset)
        guard !whereToInsert.contains(currentPhrase) else {
            return
        }

        let indexToInsert = 3;//GameConfig.placeInQueueMaxOffset + Int(arc4random() % UInt32(GameConfig.placeInQueueMaxOffset - GameConfig.placeInQueueMinOffset))

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
