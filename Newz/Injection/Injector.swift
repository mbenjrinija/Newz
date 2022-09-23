//
//  Injector.swift
//  Newz
//
//  Created by Mouad Bj on 16/9/2022.
//

import Foundation

/// Dependency Injector
protocol Injector {
  func register<Value>(_ injectable: Injectable<Value>, resolve: (Injector) throws -> Value) -> Self
  func resolve<Value>(_ injectable: Injectable<Value>) throws -> Value
}

/// A read only Property Wrapper
@propertyWrapper
struct Inject<T> {
  private let injectable: Injectable<T>
  var wrappedValue: T {
    // force unwrap > crash if value doesn't exist
    get { try! DIContainer.default.resolve(injectable) }
  }

  init(_ injectable: Injectable<T>) {
    self.injectable = injectable
  }
}

enum InjectionError: Error {
  case unregistered
}
