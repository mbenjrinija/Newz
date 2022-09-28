//
//  ErrorAlert.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 28/9/2022.
//

import Foundation
import SwiftUI

struct AlertView: ViewModifier {
  @Binding var error: ErrorAlert?
  @State var isPresented = false
  func body(content: Content) -> some View {
    content
      .alert(item: $error) { currentAlert in
        Alert(title: Text("Error"),
          message: Text(currentAlert.message),
          dismissButton: .default(Text("Ok")) {
            currentAlert.dismissAction?()
          }
        )
      }
  }
}

extension View {
  func alert(error: Binding<ErrorAlert?>) -> some View {
        modifier(AlertView(error: error))
    }
}

struct ErrorAlert: Identifiable {
    var id = UUID()
    var message: String
    var dismissAction: (() -> Void)?
}
