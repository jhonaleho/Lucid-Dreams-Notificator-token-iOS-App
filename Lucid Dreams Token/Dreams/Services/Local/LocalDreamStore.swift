//
//  LocalDreamStore.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 29/6/26.
//

import Foundation
import SwiftData

final class LocalDreamStore {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Trae todos los sueños almacenados localmente ordenados por fecha de creación (más recientes primero).
    func fetchDreams() throws -> [DreamEntry] {
        // 1. Definimos el descriptor de la consulta, especificando el ordenamiento
        let descriptor = FetchDescriptor<DreamEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        // 2. Ejecutamos la búsqueda en el contexto de SwiftData
        let entities = try context.fetch(descriptor)
        
        // 3. Transformamos las entidades de SwiftData a modelos de dominio usando el Mapper del PR-4
        return entities.map { $0.toDreamEntry() }
    }

    // MARK: - PR-6: Create
        func addDream(_ dream: DreamEntry) throws {
            let entity = DreamEntity(from: dream)
            context.insert(entity)
            try context.save()
        }

        // MARK: - PR-7: Update
        func updateDream(_ dream: DreamEntry) throws {
            // Extraemos el id a una constante local para que el macro #Predicate funcione correctamente
            let id = dream.id
            let descriptor = FetchDescriptor<DreamEntity>(
                predicate: #Predicate { $0.id == id }
            )
            
            // Buscamos la entidad original. Si no existe, no hacemos nada (podríamos lanzar un error personalizado si lo preferimos).
            guard let entityToUpdate = try context.fetch(descriptor).first else { return }
            
            // Mutamos las propiedades de la entidad rastreada
            entityToUpdate.title = dream.title
            entityToUpdate.content = dream.content
            entityToUpdate.createdAt = dream.createdAt
            
            try context.save()
        }

        // MARK: - PR-8: Delete
        func deleteDream(_ dream: DreamEntry) throws {
            // Igual que en update, necesitamos localizar la instancia exacta que maneja el context
            let id = dream.id
            let descriptor = FetchDescriptor<DreamEntity>(
                predicate: #Predicate { $0.id == id }
            )
            
            guard let entityToDelete = try context.fetch(descriptor).first else { return }
            
            context.delete(entityToDelete)
            try context.save()
        }
}
