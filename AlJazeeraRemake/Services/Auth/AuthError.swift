//
//  AuthError.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import Foundation

enum AuthError: LocalizedError {
    case missingClientID
    case missingPresenter
    case missingIDToken
    case missingAppleToken
    
    var errorDescription: String? {
        switch self {
        case .missingClientID:
            return "Missing Google client ID."
        case .missingPresenter:
            return "Unable to find a presenter for authentication."
        case .missingIDToken:
            return "Missing ID token."
        case .missingAppleToken:
            return "Missing Apple identity token."
        }
    }
}

