//
//  AuthService.swift
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 17/6/26.
//
//
//  AuthService.swift
//  Lucid Dreams Token
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

final class AuthService {
    
    static let shared = AuthService()
    
    private init() {}
    
    func signInWithGoogle() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.missingClientID
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let rootViewController = await getRootViewController() else {
            throw AuthError.missingRootViewController
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.missingIDToken
        }
        
        let accessToken = result.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: accessToken
        )
        
        try await Auth.auth().signIn(with: credential)
    }
    
    func signOut() throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
    
    @MainActor
    private func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        
        guard let window = scene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        return window.rootViewController
    }
}

enum AuthError: LocalizedError {
    case missingClientID
    case missingRootViewController
    case missingIDToken
    
    var errorDescription: String? {
        switch self {
        case .missingClientID:
            return "No se encontró el Client ID de Firebase."
        case .missingRootViewController:
            return "No se pudo encontrar la ventana principal de la app."
        case .missingIDToken:
            return "No se pudo obtener el token de Google."
        }
    }
}

