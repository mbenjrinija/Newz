//
//  OptionalGeometryEffect.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 8/10/2022.
//

import SwiftUI

extension View {
  @ViewBuilder
  @inlinable func optionalGeometryEffect(id: String,
                                         properties: MatchedGeometryProperties = .frame,
                                         anchor: UnitPoint = .center,
                                         isSource: Bool = true,
                                         in namespace: Namespace.ID?) -> some View {
    if let namespace = namespace {
      matchedGeometryEffect(id: id, in: namespace,
                            properties: properties,
                            anchor: anchor,
                            isSource: isSource
      )
    } else {
      self
    }
  }
}
