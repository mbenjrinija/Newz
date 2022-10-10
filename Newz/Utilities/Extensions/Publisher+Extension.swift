//
//  Publisher+Extension.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 10/10/2022.
//

import Foundation
import Combine

extension AnyPublisher {
  func async() async throws -> Self.Output {
    try await withCheckedThrowingContinuation { continuation in
      var subscription: AnyCancellable?
      subscription = first()
        .sink(receiveCompletion: { completion in
          switch completion {
          case .failure(let error):
            continuation.resume(throwing: error)
          default: break
          }
          subscription?.cancel()
        }, receiveValue: { value in
          continuation.resume(returning: value)
        })
    }
  }
}
