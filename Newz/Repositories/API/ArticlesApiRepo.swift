//
//  Articles.swift
//  Newz
//
//  Created by Mouad Bj on 15/9/2022.
//

import Foundation
import Combine

protocol ArticlesApiRepository: ApiRepository {
  func fetchArticles(criteria: ArticleCriteria) -> AnyPublisher<ArrayResult<Article>, Error>
}

struct ArticlesApiRepoImpl: ArticlesApiRepository {

  let session: URLSession

  init(session: URLSession) {
    self.session = session
  }

  func fetchArticles(criteria: ArticleCriteria) -> AnyPublisher<ArrayResult<Article>, Error> {
      call(endpoint: Call.getArticles(criteria)).eraseToAnyPublisher()
  }

}

extension ArticlesApiRepoImpl {
  enum Call {
    case getArticles(ArticleCriteria)
  }
}

extension ArticlesApiRepoImpl.Call: APICall {
  var auth: AuthStrategy { MediaStackAuth() }
  var path: String {
    switch self {
    case .getArticles:
      return "/news"
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

  var params: [String: String]? {
    switch self {
    case .getArticles(let criteria):
      return criteria.toDictionnary()
    }
  }

  func body() throws -> Data? {
    nil
  }

}
