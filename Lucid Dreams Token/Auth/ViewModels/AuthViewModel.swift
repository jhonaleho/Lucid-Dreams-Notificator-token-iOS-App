//
//  AuthViewModel.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 17/6/26.
//
//
//  AuthViewModel.swift
//  Lucid Dreams Token
//

import Foundation
import FirebaseAuth
import Combine


@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var user: FirebaseAuth.User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        listenToAuthState()
    }
    
    deinit {
        if let authStateHandle {
            Auth.auth().removeStateDidChangeListener(authStateHandle)
        }
    }
    
    var isSignedIn: Bool {
        user != nil
    }
    
    var displayName: String {
        user?.displayName ?? "Usuario"
    }
    
    var email: String {
        user?.email ?? "Sin correo"
    }
    
    var photoURL: URL? {
        user?.photoURL
    }
    
    private func listenToAuthState() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
            }
        }
    }
    
    func signInWithGoogle() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await AuthService.shared.signInWithGoogle()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signOut() {
        do {
            try AuthService.shared.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
