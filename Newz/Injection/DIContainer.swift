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
       .register(.Repository.Local.articles) { resolver in
        ArticlesDbRepoMain(persistentStore:
                            try resolver.resolve(.Provider.persistentStore))
      }.register(.Repository.Remote.articles) { _ in
        ArticlesApiRepoMain(session: urlSession)
      }.register(.Repository.Local.criterias) { resolver in
        ArticleCriteriaDbRepoMain(persistentStore:
          try resolver.resolve(.Provider.persistentStore))
      }.register(.Repository.Remote.images) { _ in
        ImageLoaderMain(session: urlSession)
      }.register(.Repository.Local.images) { _ in
        ImageCacheStoreMain()
      }
    // configure Services
    Self.default
      .register(.Service.articles) { resolver in
      #if DEBUG
      ArticlesServiceOfflineStub(persistentStore:
                                  try resolver.resolve(.Repository.Local.articles))
      #else
      ArticlesServiceMain(persistentStore:
                            try resolver.resolve(.Repository.Local.articles),
                          apiRepository:
                            try resolver.resolve(.Repository.Remote.articles))
      #endif
      }.register(.Service.criterias) { resolver in
        ArticleCriteriaServiceMain(persistentStore:
                                    try resolver.resolve(.Repository.Local.criterias))
      }.register(.Service.images) { resolver in
        ImageServiceMain(loader:
                          try resolver.resolve(.Repository.Remote.images),
                         cache:
                          try resolver.resolve(.Repository.Local.images)
        )
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
