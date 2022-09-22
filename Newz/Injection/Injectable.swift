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

extension Injectable {
  struct Provider {}
  struct Repository {
    struct Db { }
    struct Api { }
  }
}

extension Injectable.Repository.Db {
  static var articles: Injectable<ArticlesDbRepository> { .init() }
}

extension Injectable.Repository.Api {
  static var articles: Injectable<ArticlesApiRepository> { .init() }
}

extension Injectable.Provider {
  static var persistentStore: Injectable<PersistentStore> { .init() }
}
