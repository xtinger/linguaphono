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
    var allCards : [CardModel]! {get}
    func prepare(completion: PrepareCompletion)
}
