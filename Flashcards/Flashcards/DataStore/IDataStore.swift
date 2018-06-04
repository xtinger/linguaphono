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
    func statExists() -> Bool
    func loadStat() throws -> StatRoot
    func saveStat(data: StatRoot) throws
    func deleteStat()
}

protocol IConfigStore {
    func configExists() -> Bool
    func loadConfig() throws -> GameConfig
    func saveConfig(_ config: GameConfig) throws
    func deleteConfig()
}

protocol IGameStateStore1 {
    func gameStateExists() -> Bool
    func loadGameState() throws -> GameState
    func saveGameState(_ gameState: GameState) throws
    func deleteConfig()
}

