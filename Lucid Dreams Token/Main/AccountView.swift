//
//  AccountView.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 17/6/26.
//
import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                VStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 76))
                        .foregroundStyle(.secondary)
                    
                    Text(authViewModel.displayName)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(authViewModel.email)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                Button(role: .destructive) {
                    authViewModel.signOut()
                } label: {
                    Text("Cerrar sesión")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Cuenta")
        }
    }
}
