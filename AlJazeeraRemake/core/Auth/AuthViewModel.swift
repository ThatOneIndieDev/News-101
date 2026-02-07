//
//  AuthViewModel.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var userEmail: String?
    @Published var userDisplayName: String?
    @Published var providerIDs: [String] = []
    @Published var userPhotoURL: URL?
    
    private let emailService = EmailAuthService()
    private let googleService = GoogleAuthService()
    private let appleService = AppleAuthService()
    private let profileService = UserProfileService()
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = (user != nil)
            self?.userEmail = user?.email
            self?.userDisplayName = user?.displayName
            self?.providerIDs = user?.providerData.map { $0.providerID } ?? []
            self?.userPhotoURL = user?.photoURL
        }
    }
    
    deinit {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signUpWithEmail() async {
        await runAuth {
            try await self.emailService.signUp(email: self.email, password: self.password)
        }
    }
    
    func signInWithEmail() async {
        await runAuth {
            try await self.emailService.signIn(email: self.email, password: self.password)
        }
    }
    
    func signInWithGoogle() async {
        await runAuth {
            try await self.googleService.signIn()
        }
    }
    
    func signInWithApple() async {
        await runAuth {
            try await self.appleService.signIn()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            email = ""
            password = ""
            userEmail = nil
            userDisplayName = nil
            userPhotoURL = nil
            providerIDs = []
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateProfile(displayName: String, avatarURL: String) async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            guard let user = Auth.auth().currentUser else { return }
            try await profileService.updateProfile(user: user, displayName: displayName, photoURL: avatarURL)
            userDisplayName = displayName
            userEmail = user.email
            providerIDs = user.providerData.map { $0.providerID }
            userPhotoURL = user.photoURL
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func runAuth(_ action: @escaping () async throws -> Void) async {
        errorMessage = nil
        isLoading = true
        do {
            try await action()
            if let user = Auth.auth().currentUser {
                try await profileService.upsertUser(user)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
