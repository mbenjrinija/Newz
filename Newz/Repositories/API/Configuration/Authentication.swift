//
//  Authentication.swift
//  Newz
//
//  Created by Mouad Bj on 23/9/2022.
//

import Foundation

protocol AuthStrategy {
  func patch(params: [String: String]?) -> [String: String]?
  func patch(headers: [String: String]?) -> [String: String]?
}

struct MediaStackAuth: AuthStrategy {

  func patch(params: [String: String]?) -> [String: String]? {
    var patchedParams = params ?? [:]
    patchedParams["access_key"] = try! Constants.API.apiKey
    return patchedParams
  }

  func patch(headers: [String: String]?) -> [String: String]? {
    return headers
  }
}
