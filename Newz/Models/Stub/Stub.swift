//
//  Mockable.swift
//  Newz
//
//  Created by Mouad Bj on 18/9/2022.
//

import Foundation

protocol Stub {
  static var stub: [Self] { get }
}

extension Stub {
  static func loadJson<T: Decodable>(of type: T.Type,
                                     for file: StubFile) throws -> T {
    let data = try loadData(for: file)
    let jsonData = try JSONDecoder.default.decode(T.self, from: data)
    return jsonData
  }

  static func loadData(for file: StubFile) throws -> Data {
    let url = try Bundle.main.url(forResource: file.rawValue, withExtension: "json") ??
              { throw StubError.fileNotFound }()
    return try Data(contentsOf: url)
  }

}

enum StubFile: String {
  case articles
  case nonExistent // for test
}

extension JSONDecoder {
  static var `default`: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }
}

enum StubError: Error {
  case fileNotFound
}

// MARK: - Stubs
extension Article: Stub {
  static var stub: [Article] {
    (try? Self.loadJson(of: ArrayResult<Article>.self,
                        for: .articles).data) ?? []
  }
}

extension FeedViewModel: Stub {
  static var stub: [FeedViewModel] {
    [
//      FeedViewModel(name: "Headlines", criteria: ArticleCriteria(),
//           articles: .loaded(Array(Article.stub.prefix(10))), tag: 1),
//      FeedViewModel(name: "Tech", criteria: ArticleCriteria(),
//           articles: .loaded(Array(Article.stub.reversed().prefix(10))), tag: 2),
//      FeedViewModel(name: "Finance", criteria: ArticleCriteria(),
//           articles: .loaded(Array(Article.stub.dropFirst(5).prefix(10))), tag: 3)
    ]
  }
}

extension ArticleCriteria: Stub {
  static var stub: [ArticleCriteria] {[
    ArticleCriteria(name: "Tech"),
    ArticleCriteria(name: "Highlights"),
    ArticleCriteria(name: "Finance"),
    ArticleCriteria(name: "Apple"),
    ArticleCriteria(name: "Google")
  ]}
}
