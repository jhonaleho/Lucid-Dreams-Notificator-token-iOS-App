//
//  DreamContentView.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 28/6/26.
//
import SwiftUI

struct DreamContentView: View {

    let dream: DreamEntry

    var body: some View {

        Text(dream.content)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
    }
}
