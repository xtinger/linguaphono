//
//  UserDefaultsDataStore.swift
//  Flashcards
//
//  Created by Denis Voronov on 22/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class UserDefaultsDataStore {
    static let userDefaultsStatDataKey = "Stat"
    static let userDefaultsConfigKey = "Config"
    static let userDefaultsGameStateKey = "GameState"
}

extension UserDefaultsDataStore : IDataStore {
    func statExists() -> Bool {
        return UserDefaults.standard.object(forKey: UserDefaultsDataStore.userDefaultsStatDataKey) != nil
    }
    
    func loadStat() throws -> StatRoot {
        
        if let data = UserDefaults.standard.data(forKey: UserDefaultsDataStore.userDefaultsStatDataKey) {
            let decoder = JSONDecoder()
            return try decoder.decode(StatRoot.self, from: data)
        }
        else {
            throw DataStoreError.dataNotFound
        }
    }
    
    func saveStat(data: StatRoot) throws {
        let encoder = JSONEncoder()
        let json = try encoder.encode(data)
        UserDefaults.standard.set(json, forKey: UserDefaultsDataStore.userDefaultsStatDataKey)
    }
    
    func deleteStat() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsDataStore.userDefaultsStatDataKey)
    }
}

extension UserDefaultsDataStore : IConfigStore {
    func configExists() -> Bool {
        return UserDefaults.standard.object(forKey: UserDefaultsDataStore.userDefaultsConfigKey) != nil
    }
    
    func loadConfig() throws -> GameConfig {
        
        if let data = UserDefaults.standard.data(forKey: UserDefaultsDataStore.userDefaultsConfigKey) {
            let decoder = JSONDecoder()
            return try decoder.decode(GameConfig.self, from: data)
        }
        else {
            throw DataStoreError.dataNotFound
        }
    }
    
    func saveConfig(_ config: GameConfig) throws {
        let encoder = JSONEncoder()
        let json = try encoder.encode(config)
        UserDefaults.standard.set(json, forKey: UserDefaultsDataStore.userDefaultsConfigKey)
    }
    
    func deleteConfig() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsDataStore.userDefaultsConfigKey)
    }
}


extension UserDefaultsDataStore : IGameStateStore1 {
    
    func gameStateExists() -> Bool {
        return UserDefaults.standard.object(forKey: UserDefaultsDataStore.userDefaultsGameStateKey) != nil
    }
    
    func loadGameState() throws -> GameState {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsDataStore.userDefaultsGameStateKey) {
            let decoder = JSONDecoder()
            return try decoder.decode(GameState.self, from: data)
        }
        else {
            throw DataStoreError.dataNotFound
        }
    }
    
    func saveGameState(_ gameState: GameState) throws {
        let encoder = JSONEncoder()
        let json = try encoder.encode(gameState)
        UserDefaults.standard.set(json, forKey: UserDefaultsDataStore.userDefaultsConfigKey)
    }
    
    
    
}
