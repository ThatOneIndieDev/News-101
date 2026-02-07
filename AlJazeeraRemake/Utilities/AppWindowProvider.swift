//
//  AppWindowProvider.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import UIKit

enum AppWindowProvider {
    static func rootViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
        let window = windowScene?.windows.first { $0.isKeyWindow }
        return window?.rootViewController
    }
}

