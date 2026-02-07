//
//  UserProfileService.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class UserProfileService {
    private let db = Firestore.firestore()
    
    func upsertUser(_ user: User) async throws {
        let data: [String: Any] = [
            "uid": user.uid,
            "email": user.email ?? "",
            "displayName": user.displayName ?? "",
            "photoURL": user.photoURL?.absoluteString ?? "",
            "providerIDs": user.providerData.map { $0.providerID },
            "lastLoginAt": Timestamp(date: Date())
        ]
        try await setDocument(data, for: user.uid)
    }
    
    func updateProfile(user: User, displayName: String, photoURL: String) async throws {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        if let url = URL(string: photoURL), !photoURL.isEmpty {
            changeRequest.photoURL = url
        }
        try await changeRequest.commitChanges()
        
        let data: [String: Any] = [
            "displayName": displayName,
            "photoURL": photoURL
        ]
        try await setDocument(data, for: user.uid)
    }
    
    private func setDocument(_ data: [String: Any], for uid: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("users").document(uid).setData(data, merge: true) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
