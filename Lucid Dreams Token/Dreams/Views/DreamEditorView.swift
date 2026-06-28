//
//  DreamEditorView.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 17/6/26.
//

import SwiftUI

struct DreamEditorView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: DreamViewModel
    let dream: DreamEntry?
    
    @State private var title = ""
    @State private var content = ""
    
    init(
        viewModel: DreamViewModel,
        dream: DreamEntry? = nil
    ) {
        self.viewModel = viewModel
        self.dream = dream

        _title = State(initialValue: dream?.title ?? "")
        _content = State(initialValue: dream?.content ?? "")
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("Title") {
                    TextField(
                        "Dream title",
                        text: $title
                    )
                }
                
                Section("Dream") {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle("New Dream")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        
                        guard !content.isEmpty else {
                            return
                        }
                        
                        viewModel.addDream(
                            title: title.isEmpty ? "Untitled Dream" : title,
                            content: content
                        )
                        
                        dismiss()
                    }
                }
            }
        }
    }
}
