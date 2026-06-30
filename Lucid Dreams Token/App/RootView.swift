//
//  rootView.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 29/6/26.
//
import SwiftUI
import SwiftData

struct RootView: View{
    @Environment(\.modelContext)
    private var modelContext
    
    var body: some View{
        
        ContentView(
            appContainer: AppContainer(
                modelContext: modelContext
            )
        )
    }
    
    
}
