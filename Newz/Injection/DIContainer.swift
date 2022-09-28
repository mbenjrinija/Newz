//
//  DIContainer.swift
//  Newz
//
//  Created by Mouad Bj on 22/9/2022.
//

import Foundation

/// Dependency Injection Container
class DIContainer: Injector {
  static var `default` = DIContainer()
  private var components = [String: Any]()
  private init() { }

  @discardableResult // for chaining
  func register<T>(_ injectable: Injectable<T>, resolve: (Injector) throws -> T) -> Self {
    do {
      components[injectable.identifier] = try resolve(self)
    } catch {
      fatalError(error.localizedDescription)
    }
    return self
  }

  func resolve<T>(_ injectable: Injectable<T>) throws -> T {
    try (components[injectable.identifier] as? T) ?? {
      throw InjectionError.unregistered(injectable.identifier)
    }()
  }

  func reset() {
    components.removeAll()
  }
}

// MARK: - DI Configuration
extension DIContainer {

  static func configure() throws {
    let urlSession: URLSession = .default
    // configure Providers
    Self.default
      .register(.Provider.persistentStore) { _ in
        CoreDataStack()
      }
    // configure Repositories
    Self.default
       .register(.Repository.Db.articles) { resolver in
        ArticlesDbRepoImpl(persistentStore:
                            try resolver.resolve(.Provider.persistentStore))
      }.register(.Repository.Api.articles) { _ in
        ArticlesApiRepoImpl(session: urlSession)
      }.register(.Repository.Db.criterias) { resolver in
        ArticleCriteriaDbRepoImpl(persistentStore:
          try resolver.resolve(.Provider.persistentStore))
      }
    // configure Services
    Self.default
      .register(.Service.articles) { resolver in
        ArticlesServiceImpl(persistentStore:
                              try resolver.resolve(.Repository.Db.articles),
                            apiRepository:
                              try resolver.resolve(.Repository.Api.articles))
    }.register(.Service.criterias) { resolver in
      ArticleCriteriaServiceImpl(persistentStore:
                                  try resolver.resolve(.Repository.Db.criterias))
    }
  }

}

extension URLSession {
  static var `default`: URLSession {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 60
    configuration.timeoutIntervalForResource = 120
    configuration.waitsForConnectivity = true
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    configuration.urlCache = .shared
    return URLSession(configuration: configuration)
  }
}
