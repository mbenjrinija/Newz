//
//  ButtonStyle.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 26/9/2022.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Spacer()
      configuration.label
        .foregroundColor(.white)
      Spacer()
    }
    .padding()
    .background(Color.blue.cornerRadius(8))
    .scaleEffect(configuration.isPressed ? 0.96 : 1)
  }
}

struct PlainButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.96 : 1)
  }
}
