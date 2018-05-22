//
//  DataService.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class DataServiceV2 : IDataService{
    
    var statRoot: StatRoot?
    
    var currentLesson: StatLesson?

    enum DataServiceV2Errors: Error {
        case invalidUrl
    }
    
    required init() {
    }
        
    func prepare(completion: IDataService.PrepareCompletion?) {
        
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
                
                self.currentLesson = self.statRoot?.blocks.first?.lessons.first
                
                if let completion = completion {
                    DispatchQueue.main.async( execute: {
                        completion()
                    })
                }

                print("prepare OK")

            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
}
