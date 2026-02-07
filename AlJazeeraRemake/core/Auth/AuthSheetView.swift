//
//  AuthSheetView.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import SwiftUI
import Combine

enum AuthMode {
    case login
    case signup
    
    var title: String {
        switch self {
        case .login: return "Log In"
        case .signup: return "Sign Up"
        }
    }
    
    var primaryButtonTitle: String {
        switch self {
        case .login: return "Log In"
        case .signup: return "Create Account"
        }
    }
}

struct AuthSheetView: View {
    let mode: AuthMode
    @ObservedObject var vm: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                AuthField(title: "Email", text: $vm.email, isSecure: false)
                AuthField(title: "Password", text: $vm.password, isSecure: true)
                
                if let error = vm.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    Task {
                        switch mode {
                        case .login:
                            await vm.signInWithEmail()
                        case .signup:
                            await vm.signUpWithEmail()
                        }
                        if vm.isAuthenticated {
                            dismiss()
                        }
                    }
                } label: {
                    AuthPrimaryButton(title: mode.primaryButtonTitle, isLoading: vm.isLoading)
                }
                .buttonStyle(.plain)
                .disabled(vm.isLoading)
                
                Divider()
                    .overlay(Color.white.opacity(0.15))
                
                VStack(spacing: 12) {
                    Button {
                        Task {
                            await vm.signInWithGoogle()
                            if vm.isAuthenticated {
                                dismiss()
                            }
                        }
                    } label: {
                        AuthCapsuleButton(title: "Continue with Google", systemImage: "globe")
                    }
                    .buttonStyle(.plain)
                    .disabled(vm.isLoading)
                    
                    Button {
                        Task {
                            await vm.signInWithApple()
                            if vm.isAuthenticated {
                                dismiss()
                            }
                        }
                    } label: {
                        AuthCapsuleButton(title: "Continue with Apple", systemImage: "apple.logo")
                    }
                    .buttonStyle(.plain)
                    .disabled(vm.isLoading)
                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle(mode.title)
            .overlay {
                if vm.isLoading {
                    ZStack {
                        Color.black.opacity(0.35).ignoresSafeArea()
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
            }
        }
    }
}

private struct AuthField: View {
    let title: String
    @Binding var text: String
    let isSecure: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
            if isSecure {
                SecureField(title, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else {
                TextField(title, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }
}

private struct AuthPrimaryButton: View {
    let title: String
    let isLoading: Bool
    
    var body: some View {
        HStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            Text(title)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white)
        .foregroundStyle(.black)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct AuthCapsuleButton: View {
    let title: String
    let systemImage: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
            Text(title)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.12))
        .foregroundStyle(.white)
        .clipShape(Capsule())
        .overlay(
            Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
