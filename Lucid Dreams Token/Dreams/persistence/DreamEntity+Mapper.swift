//
//  DreamEntity+Mapper.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 29/6/26.
//

import Foundation

// MARK: - Mapeo a Modelo de Dominio
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

// MARK: - Mapeo desde Modelo de Dominio
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
