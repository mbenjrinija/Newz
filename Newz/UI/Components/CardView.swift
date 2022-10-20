//
//  CardView.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 18/10/2022.
//

import SwiftUI

struct CardViewModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .cornerRadius(22)
      .shadow(color: Color.black.opacity(0.6), radius: 6, x: 0, y: 3)
  }
}

extension View {
  func card() -> some View {
    modifier(CardViewModifier())
  }
}
