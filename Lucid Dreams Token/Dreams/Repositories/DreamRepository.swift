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
    ///
    /// - Note: **Limitaciones de Diseño de la Fase 1 (JD-008):**
    ///   1. *Resolución de Conflictos:* Al carecer de una propiedad `updatedAt`, no se realiza una comparación real de marcas de tiempo;
    ///      el flujo asume de forma optimista que el dato local o remoto es consistente. Se requerirá migración del modelo en el futuro.
    ///   2. *Borrados Remotos:* Este método no procesa eliminaciones en la nube. Si un sueño fue borrado desde otro dispositivo,
    ///      permanecerá en el almacenamiento local. Se abordará en una historia posterior (Sincronización Avanzada).
    ///   3. *Responsabilidad:* Actualmente centraliza descarga, mapeo y reconciliación. Si el algoritmo escala, se delegará
    ///      en un `DreamMergePolicy` o `DreamSynchronizationService`.
    func synchronizeRemoteDreams(for userId: String) async throws {
        // 1. Descargamos los DTOs desde el servidor remoto
        let remoteDTOs = try await remoteStore.fetchDreams(for: userId)
        
        // 2. Traemos el estado local actual para optimizar la búsqueda en memoria mediante un Set O(1)
        let localDreams = try localStore.fetchDreams()
        let localIds = Set(localDreams.map { $0.id })
        
        // 3. Reconciliación unidireccional básica (Remoto -> Local)
        for dto in remoteDTOs {
            guard let remoteDream = dto.toDreamEntry() else { continue }
            
            if localIds.contains(remoteDream.id) {
                // Idempotencia básica: Forzamos sobreescritura local para asegurar paridad de datos
                try localStore.updateDream(remoteDream)
            } else {
                // Registro de nueva entidad descargada
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
