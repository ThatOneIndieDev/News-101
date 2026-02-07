//
//  EmailAuthService.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import Foundation
import FirebaseAuth

final class EmailAuthService {
    func signUp(email: String, password: String) async throws {
        _ = try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
    }
}

