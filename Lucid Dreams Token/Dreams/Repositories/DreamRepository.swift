import Foundation

final class DreamRepository {

    private let localStore: LocalDreamStore
    private let remoteStore: RemoteDreamStore

    init(
        localStore: LocalDreamStore = LocalDreamStore(),
        remoteStore: RemoteDreamStore = RemoteDreamStore()
    ) {
        self.localStore = localStore
        self.remoteStore = remoteStore
    }

    func fetchDreams() -> [DreamEntry] {
        return []
    }

    func addDream(_ dream: DreamEntry) {

    }

    func updateDream(_ dream: DreamEntry) {

    }

    func deleteDream(_ dream: DreamEntry) {

    }
}
