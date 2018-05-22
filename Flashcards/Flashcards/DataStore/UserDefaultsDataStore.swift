//
//  UserDefaultsDataStore.swift
//  Flashcards
//
//  Created by Denis Voronov on 22/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class UserDefaultsDataStore : IDataStore{

    func dataExists() -> Bool {
        return UserDefaults.standard.object(forKey: DataService.userDefaultsStatDataKey) != nil
    }
    
    func load() throws -> StatRoot {

        if let data = UserDefaults.standard.data(forKey: DataService.userDefaultsStatDataKey) {
            let decoder = JSONDecoder()
            return try decoder.decode(StatRoot.self, from: data)
        }
        else {
            throw DataStoreError.dataNotFound
        }
    }
    
    func save(data: StatRoot) throws {
        let encoder = JSONEncoder()
        let json = try encoder.encode(data)
        UserDefaults.standard.set(json, forKey: DataService.userDefaultsStatDataKey)
    }
}
