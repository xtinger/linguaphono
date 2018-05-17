//
//  DataService.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class DataServiceV2 : IDataService{

    enum DataServiceV2Errors: Error {
        case invalidUrl
    }
    
    var cards: [CardModel] = []
    var currentCardIndex :Int = 0

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
                let phrases = root.blocks
                    .flatMap{return $0.lessons}
                    .flatMap{return $0.words}
                    .flatMap{return $0.phrases}
                self.cards = phrases.map({ (phrase) -> CardModel in
                    return CardModel(id: 0, textEng: phrase.textNormal, textRu: phrase.textBack, corrects: 0, incorrects: 0)
                })
                print("OK \(phrases.count)")
                
                if let completion = completion {
                    DispatchQueue.main.async( execute: {
                        completion()
                    })
                }
                
            } catch {
                print(error)
            }
        }
        dataTask.resume()
        
//        do {
//            guard let url = URL(string: "http://api.jsoneditoronline.org/v1/docs/65e7bbf9db7e4d23a5393ed969358cee/data") else {throw DataServiceV2Errors.invalidUrl}
//            let data = try Data(contentsOf: url, options: .mappedIfSafe)
//            let decoder = JSONDecoder()
//            let root = try decoder.decode(Root.self, from: data)
//            let phrases = root.blocks
//                .flatMap{return $0.lessons}
//                .flatMap{return $0.words}
//                .flatMap{return $0.phrases}
//            print("OK \(phrases.count)")
//        }
//        catch {
//            print(error.localizedDescription)
//        }
    }
}
