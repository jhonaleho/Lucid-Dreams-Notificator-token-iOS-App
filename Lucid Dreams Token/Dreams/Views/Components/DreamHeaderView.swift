//
//  DreamHeaderView.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 28/6/26.
//

import SwiftUI

struct DreamHeaderView: View {

    let dream: DreamEntry

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text(dream.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(
                dream.createdAt,
                style: .date
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}
