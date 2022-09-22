//
//  API.swift
//  Newz
//
//  Created by Mouad Bj on 16/9/2022.
//

import Foundation
import Combine

protocol APICall {
  var path: String { get }
  var method: String { get }
  var headers: [String: String]? { get }
  func body() throws -> Data?
}

extension APICall {
  func request(baseURL: String) throws -> URLRequest {
    guard let url = URL(string: baseURL + path) else {
      throw APIError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.allHTTPHeaderFields = headers
    request.httpBody = try body()
    return request
  }
}

enum APIError: Error {
  case httpCode(Int)
  case invalidURL
  case unexpectedResponse
}

typealias HTTPCodes = Range<Int>
extension HTTPCodes {
  static let success = 200..<300
}

extension Publisher where Output == URLSession.DataTaskPublisher.Output {
  func mapData(successCodes: HTTPCodes = .success) -> AnyPublisher<Data, Error> {
    tryMap { data, response in
      // extract status code
      guard let code = (response as? HTTPURLResponse)?.statusCode else {
        throw APIError.unexpectedResponse
      }
      // throw if status code is out of success range
      guard successCodes.contains(code) else {
        throw APIError.httpCode(code)
      }
      // return data object
      return data
    }.eraseToAnyPublisher()
  }

  func decodeData<T>(successCodes: HTTPCodes = .success)
        -> AnyPublisher<T, Error> where T: Decodable {
    mapData(successCodes: successCodes)
      .decode(type: T.self, decoder: JSONDecoder.default)
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
