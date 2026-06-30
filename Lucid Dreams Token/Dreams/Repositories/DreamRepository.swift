//
//  DreamRepository.swift
//  Lucid Dreams Token
//
//  Created by Development Team on 29/6/26.
//

import Foundation

final class DreamRepository {

    private let localStore: LocalDreamStore
    private let remoteStore: RemoteDreamStore

    init(
        localStore: LocalDreamStore,
        remoteStore: RemoteDreamStore
    ) {
        self.localStore = localStore
        self.remoteStore = remoteStore
    }
    
    // MARK: - Operaciones CRUD
    
    func fetchDreams() throws -> [DreamEntry] {
        // En el futuro aquí decidiremos si buscar en remoto o local.
        // Por ahora, cumpliendo JD-007, devolvemos los locales.
        try localStore.fetchDreams()
    }
    
    func addDream(_ dream: DreamEntry) throws {
        try localStore.addDream(dream)
        // Futuro: try remoteStore.sync(...)
    }
    
    func updateDream(_ dream: DreamEntry) throws {
        try localStore.updateDream(dream)
    }
    
    func deleteDream(_ dream: DreamEntry) throws {
        try localStore.deleteDream(dream)
    }
}



