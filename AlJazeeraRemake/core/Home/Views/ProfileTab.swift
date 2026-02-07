//
//  ProfileTab.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import SwiftUI

struct ProfileTab: View {
    @ObservedObject var authVM: AuthViewModel
    @State private var showLogin = false
    @State private var showSignup = false
    @State private var showProfileSetup = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Text("Profile")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                    
                    if authVM.isAuthenticated {
                        VStack(spacing: 16) {
                            if let photoURL = authVM.userPhotoURL {
                                AsyncImage(url: photoURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Circle()
                                        .fill(Color.white.opacity(0.12))
                                }
                                .frame(width: 84, height: 84)
                                .clipShape(Circle())
                            }
                            
                            ProfileInfoCard(
                                name: authVM.userDisplayName,
                                email: authVM.userEmail,
                                providers: authVM.providerIDs
                            )
                            
                            Button {
                                authVM.signOut()
                            } label: {
                                Text("Sign Out")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.12))
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                        .frame(maxWidth: 360)
                    } else {
                        VStack(spacing: 12) {
                            Button {
                                showSignup = true
                            } label: {
                                Text("Sign Up")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.white)
                                    .foregroundStyle(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                            
                            Button {
                                showLogin = true
                            } label: {
                                Text("Log In")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.12))
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                        .frame(maxWidth: 360)
                    }
                }
                .padding(.horizontal, 24)
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showSignup) {
                AuthSheetView(mode: .signup, vm: authVM)
            }
            .sheet(isPresented: $showLogin) {
                AuthSheetView(mode: .login, vm: authVM)
            }
            .sheet(isPresented: $showProfileSetup) {
                ProfileSetupView(vm: authVM)
            }
            .overlay {
                if authVM.isLoading {
                    ZStack {
                        Color.black.opacity(0.4).ignoresSafeArea()
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
            }
            .onChange(of: authVM.isAuthenticated) { _, isAuthed in
                if isAuthed && (authVM.userDisplayName?.isEmpty ?? true) {
                    showProfileSetup = true
                }
            }
        }
    }
}

private struct ProfileInfoCard: View {
    let name: String?
    let email: String?
    let providers: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(name?.isEmpty == false ? name! : "Signed In")
                .font(.headline)
                .foregroundStyle(.white)
            
            if let email, !email.isEmpty {
                Text(email)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            if !providers.isEmpty {
                HStack(spacing: 6) {
                    ForEach(providers, id: \.self) { provider in
                        Text(providerLabel(provider))
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private func providerLabel(_ provider: String) -> String {
        switch provider {
        case "google.com": return "Google"
        case "apple.com": return "Apple"
        case "password": return "Email"
        default: return provider
        }
    }
}

#Preview {
    ProfileTab(authVM: AuthViewModel())
        .preferredColorScheme(.dark)
}
