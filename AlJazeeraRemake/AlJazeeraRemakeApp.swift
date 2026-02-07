//
//  AlJazeeraRemakeApp.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 12/01/2026.
//

import SwiftUI
import CoreData
import FirebaseCore
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true
  }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }
}


@main
struct AlJazeeraRemakeApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
