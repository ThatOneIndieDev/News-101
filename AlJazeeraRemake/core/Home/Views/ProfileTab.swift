//
//  ProfileTab.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import SwiftUI

struct ProfileTab: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Text("Profile")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                    
                    VStack(spacing: 12) {
                        Button {
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
                .padding(.horizontal, 24)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileTab()
        .preferredColorScheme(.dark)
}

