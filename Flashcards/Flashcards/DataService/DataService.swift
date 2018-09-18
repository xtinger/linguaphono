//
//  DataService.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class DataService : IDataService{
    var config: GameConfig

    var loadFromURL = false
    
    var statRoot: StatRoot?
    var currentLesson: StatLesson?
    var isSprintMode = false
    
    var resourceReader: IResourceReader?
    
    var dataStore: IDataStore & IConfigStore & IGameStateStore1

    required init(dataStore: IDataStore & IConfigStore & IGameStateStore1) {
        self.dataStore = dataStore
        self.config = GameConfig()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveConfig), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func saveConfig() {
        try! dataStore.saveConfig(config)
        try! dataStore.saveStat(data: statRoot!)
    }
    
    func isSaved() -> Bool {
        return dataStore.gameStateExists()
    }
    
    func prepare(completion: @escaping IDataService.PrepareCompletion) {
        
        if dataStore.configExists() {
            do {
                config = try dataStore.loadConfig()
            }
            catch {
                print(error)
            }
        }

        do {
            if !loadFromURL && dataStore.statExists() {
                try self.statRoot = dataStore.loadStat()
                
                if dataStore.gameStateExists() {
                    let gameState = try dataStore.loadGameState()
                    DispatchQueue.main.async( execute: {
                        completion(gameState)
                    })
                }
                else {
                    DispatchQueue.main.async( execute: {
                        completion(nil)
                    })
                }
            }
            else {
                self.resourceReader = CSVResourceReader.init(endpointURL: config.phrasesURL!)
                loadStatRoot {_ in
                    DispatchQueue.main.async( execute: {
                        completion(nil)
                    })
                }
                loadFromURL = false
            }
        }
        catch {
            
        }
    }
    
    func prepareNextGame() -> GameStartupData?{
        
        var phrases: Set<StatPhrase> = []

        if switchingToSprintMode() {
            phrases = phrasesOfCurrentLesson()
            phrases.formUnion(additionalPhrasesForSprint())
        }
        else if setupNextLesson(){
            phrases = phrasesOfCurrentLesson()
        }
        
        guard let statRoot = statRoot else {
            fatalError("StatRoot not ready")
        }
    
        var gameStartupData: GameStartupData?
        if !phrases.isEmpty {
            let block: StatBlock = statRoot.blocks[statRoot.currentBlockIndex]
            gameStartupData = GameStartupData(phraseSet: phrases, languageOriginal: block.languageOriginal, languageTranslation: block.languageTranslation)
        }
        // empty gameStartupData set means finish of block
        return gameStartupData
    }
    
    private func phrasesOfCurrentLesson() -> Set<StatPhrase>{
        guard let currentLesson = currentLesson else {return []}
        return Set(currentLesson.words.flatMap{return $0.phrases})
    }
    
    private func additionalPhrasesForSprint() -> Set<StatPhrase> {
        var result: [StatPhrase] = []
        var availablePhrases: Set<StatPhrase> = phrasesOfPreviousLessons()
        for _ in 0 ..< min(availablePhrases.count, config.maximumSprintAdditionalPhrases) {
            if let randomElement: StatPhrase = availablePhrases.randomObject() {
                if !result.contains(randomElement) {
                    result.append(randomElement)
                    availablePhrases.remove(randomElement)
                }
            }
        }
        return Set(result)
    }
    
    private func phrasesOfPreviousLessons() -> Set<StatPhrase> {
        guard let statRoot = statRoot else {return []}
        let block: StatBlock = statRoot.blocks[statRoot.currentBlockIndex]
        let previousLessons = block.lessons[0..<statRoot.currentLessonIndex]
        let phrases = previousLessons.flatMap({return $0.words}).flatMap({return $0.phrases})
        return Set(phrases)
    }
    
    private func switchingToSprintMode() -> Bool {
        guard let statRoot = statRoot else {return false}
        if isSprintMode {
            isSprintMode = false
            return false
        }
        else {
            isSprintMode = statRoot.currentLessonIndex > 0
        }
        
        return isSprintMode
    }
    
    @discardableResult
    private func setupNextLesson() -> Bool {
        guard let statRoot = statRoot else {return false}
        
        if statRoot.currentLessonIndex == -1 {
            statRoot.currentBlockIndex = 0
            statRoot.currentLessonIndex = 0
            self.currentLesson = statRoot.blocks.first?.lessons.first
            
            assert(statRoot.currentBlockIndex >= 0)
            assert(statRoot.currentLessonIndex >= 0)
            assert(self.currentLesson != nil)
            
            return true
        }
            
        let block: StatBlock = statRoot.blocks[statRoot.currentBlockIndex]
        if statRoot.currentLessonIndex < block.lessons.endIndex - 1 {
            statRoot.currentLessonIndex = block.lessons.index(after: statRoot.currentLessonIndex)
            currentLesson = statRoot.blocks[statRoot.currentBlockIndex].lessons[statRoot.currentLessonIndex]
            return true
        }
        
        return false
    }
    
    private func loadStatRoot(completion: @escaping IDataService.PrepareCompletion) {
        resourceReader?.read { [weak self] (root) in
            guard let ws = self else {return}
            ws.statRoot = ws.convertModelToStatModel(model: root)
            try! ws.dataStore.saveStat(data: ws.statRoot!)
            completion(nil)
        }
    }
    
    private func convertModelToStatModel(model: Root) -> StatRoot? {
        return StatRoot(blocks:
            model.blocks.map({ (block) -> StatBlock in
                return StatBlock(lessons:
                    block.lessons.map({ (lesson) -> StatLesson in
                        return StatLesson(words:
                            lesson.words.map({ (word) -> StatWord in
                                return StatWord(text:word.text, phrases:
                                    word.phrases.map({ (phrase) -> StatPhrase in
                                        return StatPhrase(textOriginal: phrase.textNormal, textTranslated: phrase.textBack, corrects: 0, incorrects: 0)
                                    })
                                )
                            })
                        )
                    }),
                                 languageOriginal: block.languageOriginal,
                                 languageTranslation: block.languageTranslation
                )
            })
        )
    }
    
    func deleteStat() {
        dataStore.deleteStat()
    }
}

extension Set {
    func randomObject<T>() -> T? {
        let n = Int(arc4random_uniform(UInt32(self.count)))
        let index = self.index(self.startIndex, offsetBy: n)
        return self.count > 0 ? self[index] as? T : nil
    }
}
