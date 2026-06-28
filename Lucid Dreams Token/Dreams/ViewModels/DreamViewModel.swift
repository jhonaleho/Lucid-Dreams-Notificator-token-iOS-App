import Foundation
import Combine

@MainActor
final class DreamViewModel: ObservableObject {

    @Published var dreams: [DreamEntry] = []

    func addDream(
        title: String,
        content: String
    ) {

        let dream = DreamEntry(
            title: title,
            content: content
        )

        dreams.insert(dream, at: 0)
    }

    func updateDream(_ updatedDream: DreamEntry) {

        guard let index = dreams.firstIndex(where: { $0.id == updatedDream.id }) else {
            return
        }

        dreams[index] = updatedDream
    }
    func saveDream(
        dream: DreamEntry?,
        title: String,
        content: String
    ) {

        let finalTitle = title.isEmpty ? "Untitled Dream" : title

        if var existingDream = dream {

            existingDream.title = finalTitle
            existingDream.content = content

            updateDream(existingDream)

        } else {

            addDream(
                title: finalTitle,
                content: content
            )
        }
    }

    func deleteDream(at offsets: IndexSet) {

        for index in offsets.sorted(by: >) {
            dreams.remove(at: index)
        }
    }
}
