//
//  GameService.swift
//  Flashcards
//
//  Created by Denis Voronov on 14/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class OnePortionGameService : IGameService {

    private var dataService : IDataService
    let config = GameConfig()
    var output: IGameServiceOutput!
    
    var currentBlock : StatBlock!
    var currentLesson : StatLesson!
    var words : [StatWord]!
    var phrases : [StatPhrase]!
    var current : StatPhrase!
    var currentPhraseIndex: Int = -1

    required init(dataService: IDataService) {
        self.dataService = dataService
    }
    
    func readyToPresent() {
        self.dataService.prepare { [weak self] (root) -> () in
            if let this = self {
                this.currentBlock = root.blocks.first
                //                self.output.presentCard(self.current)
                this.currentLesson = this.currentBlock.lessons.first
                this.words = this.currentLesson.words
                this.phrases = this.words.flatMap{return $0.phrases}
                this.duplicatePhrases()
                this.shufflePhrases()
                this.pickPhrase()
//                this.phrases = this.words.flatMap{return $0.phrases}
                this.output.presentCard(this.phrases[this.currentPhraseIndex])
            }
        }
    }
    
    func duplicatePhrases() {
        let phrases1piece = phrases!
        var result = [StatPhrase]()
        for _ in 1...GameConfig.newLessonPhaseMinQuestionsForeachPhrase {
            result += phrases1piece
        }
        self.phrases = result
    }
    
    @discardableResult
    func pickPhrase() -> Bool {
        // -1, 0 ... n-1
        if currentPhraseIndex < phrases.count - 1 {
            currentPhraseIndex += 1
            current = phrases[currentPhraseIndex]
            return true
        }
        else {
            return false
        }
    }
    
    func shufflePhrases() {
        var result :[StatPhrase] = phrases
        
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
        
        self.phrases = result
    }

    func answered(with action: GameInputAction) {
        
        switch action {
        case .Yes:
            current.corrects += 1
        case .No:
            current.incorrects += 1
        case .Repeat:
            break
        }
        
        if pickPhrase() {
            output.presentCard(current)
        }
        else {
            output.finish()
        }
    }
    
    
}
