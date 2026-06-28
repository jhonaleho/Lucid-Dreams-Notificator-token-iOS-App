//
//  LoginView.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 17/6/26.
//

//
//  LoginView.swift
//  Lucid Dreams Token
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 28) {
            
            Spacer()
            
            VStack(spacing: 12) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 64))
                
                Text("Lucid Dreams Token")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Inicia sesión para guardar tus sueños en la nube.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 12) {
                GoogleSignInButton {
                    Task {
                        await authViewModel.signInWithGoogle()
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)
                
                if authViewModel.isLoading {
                    ProgressView("Iniciando sesión...")
                }
                
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            
            Spacer()
            
            Text("Tus registros se asociarán a tu cuenta de Google.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom)
        }
    }
}
