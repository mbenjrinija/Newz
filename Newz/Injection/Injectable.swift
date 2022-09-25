//
//  Injectable.swift
//  Newz
//
//  Created by Mouad Bj on 15/9/2022.
//

import Foundation

struct Injectable<T> {
  var identifier: String
  init(identifier: String) { self.identifier = identifier }
  init() { self.init(identifier: "\(T.self)") }
}

// allow nesting/shortNames for convenience reasons
// swiftlint:disable nesting
// swiftlint:disable type_name
extension Injectable {
  struct Service {}
  struct Provider {}
  struct Repository {
    struct Db { }
    struct Api { }
  }
}
// swiftlint:enable nesting
// swiftlint:enable type_name

extension Injectable.Repository.Db {
  static var articles: Injectable<ArticlesDbRepository> { .init() }
}

extension Injectable.Repository.Api {
  static var articles: Injectable<ArticlesApiRepository> { .init() }
}

extension Injectable.Provider {
  static var persistentStore: Injectable<PersistentStore> { .init() }
}

extension Injectable.Service {
  static var articles: Injectable<ArticlesService> { .init() }
}
