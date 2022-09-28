//
//  ApiCall.swift
//  Newz
//
//  Created by Mouad Bj on 16/9/2022.
//

import Foundation
import Combine

protocol APICall {
  var baseURL: String { get }
  var path: String { get }
  var method: String { get }
  var headers: [String: String]? { get }
  var params: [String: String]? { get }
  func body() throws -> Data?
  var auth: AuthStrategy { get }

}

extension APICall {

  var baseURL: String { Constants.API.baseUrl }

  func request() throws -> URLRequest {
    guard var urlComponents = URLComponents(string: baseURL + path) else {
      throw APIError.invalidURL
    }
    urlComponents.queryItems = URLQueryItem.from(auth.patch(params: params))
    guard let url = urlComponents.url else {
      throw APIError.invalidQueryParams
    }
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.allHTTPHeaderFields = auth.patch(headers: headers)
    request.httpBody = try body()
    return request
  }
}

enum APIError: Error {
  case httpCode(Int, String)
  case invalidURL
  case invalidQueryParams
  case unexpectedResponse
  case apiKeyNotFound
}

typealias HTTPCodes = Range<Int>
extension HTTPCodes {
  static let success = 200..<300
}

extension URLQueryItem {
  static func from(_ params: [String: String]?) -> [Self] {
    params?.map {self.init(name: $0.key, value: $0.value)} ?? []
  }
}
