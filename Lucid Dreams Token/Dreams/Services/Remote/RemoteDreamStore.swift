//
//  RemoteDreamStore.swift
//  Lucid Dreams Token
//
//  Created by Development Team on 2026.
//

import Foundation
import FirebaseFirestore

final class RemoteDreamStore {
    
    private let database: Firestore
    
    // Recomendada 1: Inyección de la instancia con valor por defecto
    init(database: Firestore = .firestore()) {
        self.database = database
    }
    
    // MARK: - Helpers de Ruta
    
    /// Define la subcolección jerárquica de sueños para un usuario específico: users/{userId}/dreams
    private func dreamsCollection(for userId: String) -> CollectionReference {
        database
            .collection("users")
            .document(userId)
            .collection("dreams")
    }
    
    // MARK: - Operaciones CRUD Remotas
    
    /// Recupera todos los documentos de sueños del usuario en Firestore.
    func fetchDreams(for userId: String) async throws -> [FirestoreDreamDTO] {
        let snapshot = try await dreamsCollection(for: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: FirestoreDreamDTO.self)
        }
    }
    
    /// Inserta o sobrescribe un sueño en la base de datos remota.
    func addDream(_ dto: FirestoreDreamDTO, for userId: String) async throws {
        try dreamsCollection(for: userId)
            .document(dto.id)
            .setData(from: dto)
    }
    
    /// Actualiza los campos modificados de un sueño en Firestore.
    func updateDream(_ dto: FirestoreDreamDTO, for userId: String) async throws {
        try dreamsCollection(for: userId)
            .document(dto.id)
            .setData(from: dto, merge: true)
    }
    
    /// Elimina de forma permanente el documento en el servidor.
    func deleteDream(id: String, for userId: String) async throws {
        try await dreamsCollection(for: userId)
            .document(id)
            .delete()
    }
}
