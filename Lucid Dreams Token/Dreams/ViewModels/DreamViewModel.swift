//
//  DreamViewModel.swift
//  Lucid Dreams Token
//
//  Created by Development Team on 29/6/26.
//

import Foundation
import Combine

@MainActor
final class DreamViewModel: ObservableObject {

    /// El arreglo de sueños ahora es estrictamente una proyección de la base de datos.
    @Published var dreams: [DreamEntry] = []
    
    private let dreamRepository: DreamRepository
    
    init(repository: DreamRepository) {
        self.dreamRepository = repository
        // 5. El ViewModel nace con datos inmediatamente, la View no tiene que recordar cargarlos.
        fetchDreams()
    }

    // MARK: - Fuente Única de Verdad (Sincronización de UI)
    
    /// Método privado centralizado para refrescar el estado de la UI desde la persistencia.
    private func reloadDreams() {
        do {
            dreams = try dreamRepository.fetchDreams()
        } catch {
            // TODO: Cambiar por Logger.persistence.error en el próximo Sprint de monitoreo
            print("Error al recargar los sueños: \(error.localizedDescription)")
        }
    }
    
    func fetchDreams() {
        reloadDreams()
    }
    // MARK: - Operaciones de Escritura

    func addDream(
        title: String,
        content: String
    ) {
        let dream = DreamEntry(
            title: title,
            content: content
        )

        do {
            try dreamRepository.addDream(dream)
            // 2. Traemos la verdad absoluta desde SwiftData eliminando la mutación manual
            reloadDreams()
        } catch {
            print("Error al añadir el sueño: \(error.localizedDescription)")
        }
    }

    func updateDream(_ updatedDream: DreamEntry) {
        do {
            try dreamRepository.updateDream(updatedDream)
            // 2. Sincronizamos la UI forzando la lectura del nuevo estado guardado
            reloadDreams()
        } catch {
            print("Error al actualizar el sueño: \(error.localizedDescription)")
        }
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
        do {
            // Identificamos las entidades físicas mapeando los índices antes de alterar nada
            let dreamsToDelete = offsets.map { dreams[$0] }
            
            for dream in dreamsToDelete {
                try dreamRepository.deleteDream(dream)
            }
            
            // 2. En lugar de remover del arreglo local, consultamos el disco para validar el borrado
            reloadDreams()
        } catch {
            print("Error al eliminar el sueño: \(error.localizedDescription)")
        }
    }
}
