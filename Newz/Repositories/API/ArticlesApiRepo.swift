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
    let request: AnyPublisher<ArrayResult<Article>, Error> =
      call(endpoint: Call.getArticles)
    return request
      .map(\.data)
      .replaceNil(with: [])
      .eraseToAnyPublisher()
  }

}

extension ArticlesApiRepoImpl {
  enum Call {
    case getArticles
  }
}

extension ArticlesApiRepoImpl.Call: APICall {
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
