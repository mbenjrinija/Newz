//
//  Mockable.swift
//  Newz
//
//  Created by Mouad Bj on 18/9/2022.
//

import Foundation

protocol Mockable {
  static var mock: [Self] { get }
}

extension Article: Mockable {
  static var mock: [Article] {
    Self.loadMock(of: ArrayResult<Article>.self, fromFile: "articles")?.data ?? []
  }

}

extension Mockable {
  static func loadMock<T: Decodable>(of type: T.Type, fromFile fileName: String) -> T? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
      do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let jsonData = try decoder.decode(T.self, from: data)
        return jsonData
      } catch {
        print("error: \(error)")
      }
    }
    return nil
  }
}
