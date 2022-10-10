//
//  Loadable.swift
//  Newz
//
//  Created by Mouad Bj on 24/9/2022.
//

import Foundation
import Combine
import SwiftUI

typealias CancelBag = Set<AnyCancellable>

enum Loadable<T> {
  case notLoaded
  case loading(T?, AnyCancellable)
  case failed(T?, Error)
  case loaded(T)

  var value: T? {
    switch self {
    case .loading(let latest, _): return latest
    case .failed(let latest, _): return latest
    case .loaded(let value): return value
    default: return nil
    }
  }

  var error: Error? {
    switch self {
    case .failed(_, let error): return error
    default: return nil
    }
  }
}

extension Loadable: Equatable {
  static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
    String(describing: lhs) == String(describing: rhs)
  }
}

extension Publisher {
  func assignTo(_ loadable: Binding<Loadable<Self.Output>>) {
    let latest = loadable.wrappedValue.value
    let cancellable = self
      .receive(on: DispatchQueue.main)
      .sink { completion in
      if case let .failure(error) = completion {
        loadable.wrappedValue = .failed(latest, error)
      }
    } receiveValue: { value in
      loadable.wrappedValue = .loaded(value)
    }
    loadable.wrappedValue = .loading(latest, cancellable)
  }
}

extension ObservableObject {
  func bindingOf<T>(loadable: WritableKeyPath<Self, Loadable<T>>) -> Binding<Loadable<T>> {
    let current = self[keyPath: loadable]
    return .init(get: { [weak self] in
      self?[keyPath: loadable] ?? current
    }, set: { [weak self] value in
      self?[keyPath: loadable] = value
    })
  }
}
