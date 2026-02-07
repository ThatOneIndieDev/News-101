//
//  ProfileSetupView.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import SwiftUI

struct ProfileSetupView: View {
    @ObservedObject var vm: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var displayName: String = ""
    @State private var avatarURL: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Display Name")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                    TextField("Your name", text: $displayName)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .padding(12)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Avatar URL")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                    TextField("https://...", text: $avatarURL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(12)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                
                Button {
                    Task {
                        await vm.updateProfile(displayName: displayName, avatarURL: avatarURL)
                        dismiss()
                    }
                } label: {
                    Text("Save Profile")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .disabled(displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Complete Profile")
        }
    }
}

#Preview {
    ProfileSetupView(vm: AuthViewModel())
        .preferredColorScheme(.dark)
}

