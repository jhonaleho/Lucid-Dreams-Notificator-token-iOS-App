//
//  DreamEntity.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 28/6/26.
//
//
// DreamEntity.swift
//

import Foundation
import SwiftData

@Model
final class DreamEntity {

    @Attribute(.unique)
    var id: UUID

    var title: String

    var content: String

    var createdAt: Date

    init(
        id: UUID,
        title: String,
        content: String,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }
}
extension DreamEntity {

    convenience init(from dream: DreamEntry) {

        self.init(
            id: dream.id,
            title: dream.title,
            content: dream.content,
            createdAt: dream.createdAt
        )
    }
}
extension DreamEntity {

    func toDreamEntry() -> DreamEntry {

        DreamEntry(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt
        )
    }
}
