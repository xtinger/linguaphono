//
//  IDataStore.swift
//  Flashcards
//
//  Created by Denis Voronov on 22/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

enum DataStoreError: Error {
    case dataNotFound
}

protocol IDataStore {
    
    func dataExists() -> Bool
    
    func load() throws -> StatRoot
    
    func save(data: StatRoot) throws
}
