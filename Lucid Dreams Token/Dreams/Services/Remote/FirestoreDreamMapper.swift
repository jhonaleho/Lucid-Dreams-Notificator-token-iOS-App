//
//  FirestoreDreamMapper.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 1/7/26.
//


import Foundation

// MARK: - Mapeo a Modelo de Dominio
extension FirestoreDreamDTO {
    
    /// Convierte el DTO de Firestore a un objeto de dominio válido.
    /// Devuelve `nil` si el ID almacenado en remoto no puede ser convertido a un UUID válido.
    func toDreamEntry() -> DreamEntry? {
        guard let uuid = UUID(uuidString: id) else { return nil }
        return DreamEntry(
            id: uuid,
            title: title,
            content: content,
            createdAt: createdAt
        )
    }
}

// MARK: - Mapeo desde Modelo de Dominio
extension FirestoreDreamDTO {
    
    /// Inicializador para construir el DTO requerido por Firestore a partir del Dominio.
    init(from dream: DreamEntry) {
        self.id = dream.id.uuidString
        self.title = dream.title
        self.content = dream.content
        self.createdAt = dream.createdAt
    }
}
