//
//  DataService.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class DataService : IDataService{
    static let userDefaultsStatDataKey = "Stat"
    
    var statRoot: StatRoot?
    var currentLesson: StatLesson?
    var isSprintMode = false
    
    private var dataStore: IDataStore

    enum DataServiceV2Errors: Error {
        case invalidUrl
    }
    
    required init(dataStore: IDataStore) {
        self.dataStore = dataStore
    }
        
    func prepare(completion: @escaping IDataService.PrepareCompletion) {
        
        let loadedCompletion = {
            DispatchQueue.main.async( execute: {
                completion()
            })
        }
        
        do {
            if dataStore.dataExists() {
                try self.statRoot = dataStore.load()
                loadedCompletion()
            }
            else {
                loadStatRootFromURL {
                    loadedCompletion()
                }
            }
        }
        catch {
            
        }
    }
    
    func prepareNextPhraseSet() -> Set<StatPhrase>{
        var phrases: Set<StatPhrase> = []
        if switchingToSprintMode() {
            phrases = phrasesOfCurrentLesson()
            phrases.formUnion(additionalPhrasesForSprint())
        }
        else if setupNextLesson(){
            phrases = phrasesOfCurrentLesson()
        }
        // empty phrase set means finish of block
        return phrases
    }
    
    private func phrasesOfCurrentLesson() -> Set<StatPhrase>{
        guard let currentLesson = currentLesson else {return []}
        return Set(currentLesson.words.flatMap{return $0.phrases})
    }
    
    private func additionalPhrasesForSprint() -> Set<StatPhrase> {
        var result: [StatPhrase] = []
        var availablePhrases: Set<StatPhrase> = phrasesOfPreviousLessons()
        for _ in 0 ..< min(availablePhrases.count, GameConfig.maximumSprintAdditionalPhrases) {
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
    
    func loadStatRootFromURL(completion: @escaping IDataService.PrepareCompletion) {
        let endpointURL = URL(string: "http://api.jsoneditoronline.org/v1/docs/647354f539464a22948c99613a47b269/data")
        
        let dataTask = URLSession.shared.dataTask(with: endpointURL!) { data, response, error in
            guard error == nil, let data = data else {
                print(error!)
                return
            }
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Root.self, from: data)
                self.statRoot = StatRoot(blocks:
                    root.blocks.map({ (block) -> StatBlock in
                        return StatBlock(lessons:
                            block.lessons.map({ (lesson) -> StatLesson in
                                return StatLesson(words:
                                    lesson.words.map({ (word) -> StatWord in
                                        return StatWord(text:word.text, phrases:
                                            word.phrases.map({ (phrase) -> StatPhrase in
                                                return StatPhrase(textEng: phrase.textNormal, textRu: phrase.textBack, corrects: 0, incorrects: 0)
                                            })
                                        )
                                    })
                                )
                            })
                        )
                    })
                )
                
                do {
                    try self.dataStore.save(data: self.statRoot!)
                }
                catch {
                    print("Unable to save game data!")
                }
                completion()
                
                print("prepare OK")
                
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
}

extension Set {
    func randomObject<T>() -> T? {
        let n = Int(arc4random_uniform(UInt32(self.count)))
        let index = self.index(self.startIndex, offsetBy: n)
        return self.count > 0 ? self[index] as? T : nil
    }
}
