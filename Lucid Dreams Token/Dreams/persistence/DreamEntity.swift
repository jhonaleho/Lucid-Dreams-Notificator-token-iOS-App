//
//  DreamEntity.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 28/6/26.
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
