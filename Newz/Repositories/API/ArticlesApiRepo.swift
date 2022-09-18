//
//  Articles.swift
//  Newz
//
//  Created by Mouad Bj on 15/9/2022.
//

import Foundation
import Combine

protocol ArticlesApiRepository: ApiRepository {
  func fetchArticles() -> AnyPublisher<[Article], Error>
}

struct ArticlesApiRepoImpl: ArticlesApiRepository {

  let session: URLSession

  init(session: URLSession) {
    self.session = session
  }

  func fetchArticles() -> AnyPublisher<[Article], Error> {
    call(endpoint: API.getArticles)
  }

}

extension ArticlesApiRepoImpl {
  enum API {
    case getArticles
  }
}

extension ArticlesApiRepoImpl.API: APICall {
  var path: String {
    switch self {
    case .getArticles:
      return "/new"
    }
  }
  var method: String {
    switch self {
    case .getArticles:
      return "GET"
    }
  }
  var headers: [String: String]? {
    return ["Accept": "application/json"]
  }
  func body() throws -> Data? {
    nil
  }
}
