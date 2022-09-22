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
    Self.loadJson(of: ArrayResult<Article>.self, for: .articles)?.data ?? []
  }
}

extension Stub {
  static func loadJson<T: Decodable>(of type: T.Type,
                                     for file: StubFile) -> T? {
    do {
      let data = try loadData(for: file) ?? { throw StubError.fileNotFound }()
      let jsonData = try JSONDecoder.default.decode(T.self, from: data)
      return jsonData
    } catch {
      print("error: \(#file) \(error)")
    }
    return nil
  }

  static func loadData(for file: StubFile) -> Data? {
    if let url = Bundle.main.url(forResource: file.rawValue, withExtension: "json") {
      return try? Data(contentsOf: url)
    }
    return nil
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
