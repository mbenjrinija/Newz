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

extension Article: Stub {
  static var stub: [Article] {
    try! Self.loadJson(of: ArrayResult<Article>.self, for: .articles).data!
  }
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
