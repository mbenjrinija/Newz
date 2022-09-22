//
//  ApiRepository.swift
//  Newz
//
//  Created by Mouad Bj on 21/9/2022.
//

import Foundation
import Combine

protocol ApiRepository {
  var session: URLSession { get }
}

extension ApiRepository {
  func call<Value>(endpoint: APICall) -> AnyPublisher<Value, Error> where Value: Decodable {
    do {
      let request = try endpoint.request(baseURL: Self.baseUrl)
      return session
        .dataTaskPublisher(for: request)
        .decodeData()
    } catch let error {
      return Fail<Value, Error>(error: error).eraseToAnyPublisher()
    }
  }
}

extension ApiRepository {
  /// Api Keys SHOULD NOT be stored in client
  /// Exception for demo purposes
  /// Force unwrap values to intentionally crash if config.plist is not created
  static var apiKey: String {
    get throws {
      let filePath = Bundle.main.path(forResource: "config", ofType: "plist")!
      let plist = NSDictionary(contentsOfFile: filePath)
      return try (plist?.object(forKey: "API_KEY") as? String) ??
                  { throw APIError.apiKeyNotFound }()
    }
  }
  static var baseUrl: String { "https://api.mediastack.com/v1" }
}
