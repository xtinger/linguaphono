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
    
    private var dataStore: IDataStore

    enum DataServiceV2Errors: Error {
        case invalidUrl
    }
    
    required init(dataStore: IDataStore) {
        self.dataStore = dataStore
    }
        
    func prepare(completion: @escaping IDataService.PrepareCompletion) {
        
        let loadedCompletion = {
            if var statRoot = self.statRoot {
                if statRoot.currentBlockIndex == -1 {
                    statRoot.currentBlockIndex = 0
                }
                if statRoot.currentLessonIndex == -1 {
                    statRoot.currentLessonIndex = 0
                }
                self.currentLesson = statRoot.blocks[statRoot.currentBlockIndex].lessons[statRoot.currentLessonIndex]
                
                assert(statRoot.currentBlockIndex >= 0)
                assert(statRoot.currentLessonIndex >= 0)
                assert(self.currentLesson != nil)
            }

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
    
    func nextLesson() -> Bool {
        guard let statRoot = statRoot else {return false}
        
        let block: StatBlock = statRoot.blocks[statRoot.currentBlockIndex]
        if statRoot.currentLessonIndex < block.lessons.endIndex - 1 {
            statRoot.currentLessonIndex = block.lessons.index(after: statRoot.currentLessonIndex)
            currentLesson = statRoot.blocks[statRoot.currentBlockIndex].lessons[statRoot.currentLessonIndex]
            return true
        }
        else {
            return false
        }
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
