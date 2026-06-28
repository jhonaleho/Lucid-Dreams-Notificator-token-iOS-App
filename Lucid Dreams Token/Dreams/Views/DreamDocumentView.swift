//
//  DreamDocumentView.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 28/6/26.
//
import SwiftUI

struct DreamDocumentView: View {

    let dream: DreamEntry

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                DreamHeaderView(
                    dream: dream
                )

                DreamContentView(
                    dream: dream
                )
            }
            .padding()
        }
        .navigationTitle("Dream")
        .navigationBarTitleDisplayMode(.inline)
    }
}
