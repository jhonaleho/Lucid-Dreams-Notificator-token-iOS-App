//
//  DreamRepository.swift
//  Lucid Dreams Token
//
//  Created by Development Team on 2026.
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
    
    // MARK: - Operaciones de Lectura e Sincronización Inicial
    
    func fetchDreams() throws -> [DreamEntry] {
        try localStore.fetchDreams()
    }
    
    /// Sincroniza el historial remoto de Firestore hacia el almacén local.
    /// Este método debe ser invocado al arrancar la app con sesión activa o tras un login exitoso.
    func synchronizeRemoteDreams(for userId: String) async throws {
        // 1. Descargamos los DTOs desde el servidor remoto
        let remoteDTOs = try await remoteStore.fetchDreams(for: userId)
        
        // 2. Traemos lo que ya tenemos guardado localmente para comparar en memoria y optimizar accesos a disco
        let localDreams = try localStore.fetchDreams()
        let localIds = Set(localDreams.map { $0.id })
        
        // 3. Procesamos e integramos los datos devueltos por el servidor
        for dto in remoteDTOs {
            // Transformamos el DTO al modelo de dominio
            guard let remoteDream = dto.toDreamEntry() else { continue }
            
            if localIds.contains(remoteDream.id) {
                // Idempotencia: Si ya existe localmente, actualizamos su contenido por si hubo cambios en la nube
                try localStore.updateDream(remoteDream)
            } else {
                // Si el sueño es nuevo para el dispositivo, lo insertamos de inmediato
                try localStore.addDream(remoteDream)
            }
        }
    }
    
    // MARK: - Operaciones de Escritura Dual (Local + Remoto)
    
    func addDream(_ dream: DreamEntry, userId: String?) async throws {
        try localStore.addDream(dream)
        guard let userId = userId else { return }
        
        do {
            let dto = FirestoreDreamDTO(from: dream)
            try await remoteStore.addDream(dto, for: userId)
        } catch {
            print("⚠️ [Repository] Sincronización remota fallida al añadir: \(error.localizedDescription)")
        }
    }
    
    func updateDream(_ dream: DreamEntry, userId: String?) async throws {
        try localStore.updateDream(dream)
        guard let userId = userId else { return }
        
        do {
            let dto = FirestoreDreamDTO(from: dream)
            try await remoteStore.updateDream(dto, for: userId)
        } catch {
            print("⚠️ [Repository] Sincronización remota fallida al actualizar: \(error.localizedDescription)")
        }
    }
    
    func deleteDream(_ dream: DreamEntry, userId: String?) async throws {
        try localStore.deleteDream(dream)
        guard let userId = userId else { return }
        
        do {
            try await remoteStore.deleteDream(id: dream.id.uuidString, for: userId)
        } catch {
            print("⚠️ [Repository] Sincronización remota fallida al eliminar: \(error.localizedDescription)")
        }
    }
}
