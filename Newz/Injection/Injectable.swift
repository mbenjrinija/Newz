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
extension Injectable {
  struct Service {}
  struct Provider {}
  struct Repository {
    struct Local { }
    struct Remote { }
  }
}
// swiftlint:enable nesting

extension Injectable.Repository.Local {
  static var articles: Injectable<ArticlesDbRepository> { .init() }
  static var criterias: Injectable<ArticleCriteriaDbRepository> { .init() }
  static var images: Injectable<any ImageCacheStore> { .init() }
}

extension Injectable.Repository.Remote {
  static var articles: Injectable<ArticlesApiRepository> { .init() }
  static var images: Injectable<ImageLoader> { .init() }
}

extension Injectable.Provider {
  static var persistentStore: Injectable<PersistentStore> { .init() }
}

extension Injectable.Service {
  static var articles: Injectable<ArticlesService> { .init() }
  static var criterias: Injectable<ArticleCriteriaService> { .init() }
  static var images: Injectable<ImageService> { .init() }
}
