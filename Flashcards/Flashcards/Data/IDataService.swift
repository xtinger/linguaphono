//
//  IDataService.swift
//  Flashcards
//
//  Created by Denis Voronov on 08/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

protocol IDataService {
    typealias PrepareCompletion = ()->()
    
    var cards: [CardModel] {get set}
    var currentCardIndex :Int {get set}
    
    func prepare(completion: PrepareCompletion)
}

