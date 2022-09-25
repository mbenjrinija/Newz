//
//  NewzApp.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 13/9/2022.
//

import SwiftUI

@main
struct NewzApp: App {
  init() {
    do {
      try DIContainer.configure()
    } catch {
      fatalError("unable to configure DIContainer: \(error.localizedDescription)")
    }
  }
  var body: some Scene {
    WindowGroup {
        ContentView()
    }
  }
}
