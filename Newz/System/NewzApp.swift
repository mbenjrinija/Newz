//
//  NewzApp.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 13/9/2022.
//

import SwiftUI

@main
struct NewzApp: App {
  var body: some Scene {
    WindowGroup {
        ContentView()
        .onReceive(NotificationCenter.default
          .publisher(for: UIScene.willConnectNotification)) { _ in
            try! DIContainer.configure()
        }
    }
  }
}
