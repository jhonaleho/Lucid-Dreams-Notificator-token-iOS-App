//
//  DreamListView.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 17/6/26.
//

import SwiftUI

struct DreamListView: View {
    private enum EditorMode: Identifiable {

        case new
        case edit(DreamEntry)

        var id: String {
            switch self {
            case .new:
                return "new"

            case .edit(let dream):
                return dream.id.uuidString
            }
        }
    }
    @StateObject private var viewModel = DreamViewModel()
    
    
    @State private var editorMode: EditorMode?
    
    
    
    var body: some View {
        
        NavigationStack {
            
            Group {
                
                if viewModel.dreams.isEmpty {
                    
                    ContentUnavailableView(
                        "No Dreams Yet",
                        systemImage: "moon.zzz",
                        description: Text(
                            "Record your first dream."
                        )
                    )
                    
                } else {
                    
                    List {
                        
                        ForEach(viewModel.dreams) { dream in
                            
                            VStack(
                                alignment: .leading,
                                spacing: 8
                            ) {
                                
                                Text(dream.title)
                                    .font(.headline)
                                
                                Text(dream.content)
                                    .lineLimit(2)
                                
                                Text(
                                    dream.createdAt,
                                    style: .date
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                            
                            .swipeActions {
                                
                                Button {
                                    
                                    editorMode = .edit(dream)
                                    
                                } label: {
                                    
                                    Label("Edit", systemImage: "pencil")
                                    
                                }
                                .tint(.blue)
                                
                                Button(role: .destructive) {
                                    
                                    if let index = viewModel.dreams.firstIndex(where: { $0.id == dream.id }) {
                                        viewModel.dreams.remove(at: index)
                                    }
                                    
                                } label: {
                                    
                                    Label("Delete", systemImage: "trash")
                                    
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dream Journal")
            .toolbar {
                
                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    Button {
                        editorMode = .new
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $editorMode) { mode in

                switch mode {

                case .new:

                    DreamEditorView(
                        viewModel: viewModel
                    )

                case .edit(let dream):

                    DreamEditorView(
                        viewModel: viewModel,
                        dream: dream
                    )
                }
            }
        }
    }
}
