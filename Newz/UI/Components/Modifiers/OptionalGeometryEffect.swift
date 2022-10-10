//
//  OptionalGeometryEffect.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 8/10/2022.
//

import SwiftUI

extension View {
  @ViewBuilder
  @inlinable func optionalGeometryEffect(id: String, in namespace: Namespace.ID?) -> some View {
    if let namespace = namespace {
      matchedGeometryEffect(id: id, in: namespace)
    } else {
      self
    }
  }
}
