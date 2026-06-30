//
//  appContainer.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 29/6/26.
//
import SwiftData
final class AppContainer{
    let modelContext: ModelContext
    let localDreamStore: LocalDreamStore
    let remoteDreamStore: RemoteDreamStore
    let dreamRepository: DreamRepository
    
    init(modelContext: ModelContext){
        self.modelContext = modelContext
        self.localDreamStore = LocalDreamStore(
            context: modelContext
        )
        self.remoteDreamStore = RemoteDreamStore()
        self.dreamRepository = DreamRepository(
            localStore: localDreamStore,
            remoteStore: remoteDreamStore
        )
    }
    func makeDreamViewModel() -> DreamViewModel {
        DreamViewModel(repository: dreamRepository)
    }
}
