//
//  Injector.swift
//  Newz
//
//  Created by Mouad Bj on 16/9/2022.
//

import Foundation

/// Dependency Injector
protocol Injector {
  func register<Value>(injectable: Injectable<Value>, resolve: (Injector) throws -> Value)
  func resolve<Value>(injectable: Injectable<Value>) throws -> Value?
}

/// Dependency Injection Container
class DIContainer: Injector {

  static var `default` = DIContainer()

  private init() { }

  private var components = [String: Any]()

  func register<T>(injectable: Injectable<T>, resolve: (Injector) throws -> T) {
    do {
      components[injectable.identifier] = try resolve(self)
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  func resolve<T>(injectable: Injectable<T>) throws -> T? {
    components[injectable.identifier] as? T
  }

}

/// A read only Property Wrapper
@propertyWrapper
struct Inject<T> {
  private let injectable: Injectable<T>
  var wrappedValue: T {
    // force unwrap, throw error if value doesn't exist
    get { try! DIContainer.default.resolve(injectable: injectable)! }
  }

  init(_ injectable: Injectable<T>) {
    self.injectable = injectable
  }
}
