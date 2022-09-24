//
//  Constants.swift
//  Newz
//
//  Created by Mouad Bj on 23/9/2022.
//

import Foundation

struct Constants {
  struct API {
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
    static var baseUrl: String { "http://api.mediastack.com/v1" }
  }
}
