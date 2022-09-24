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
    try! DIContainer.configure()
  }
  var body: some Scene {
    WindowGroup {
        ContentView()
    }
  }
}
