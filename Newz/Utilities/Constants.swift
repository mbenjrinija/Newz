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
        return try (plist?.object(forKey: "API_KEY") as? String) ?? {
          throw APIError.apiKeyNotFound
        }()
      }
    }
    static var baseUrl: String { "http://api.mediastack.com/v1" }
  }

  struct Criterias {
    static let categories: [String] = [
      "general",
      "business",
      "entertainment",
      "health",
      "science",
      "sports",
      "technology"
    ]

    static let languages: [KeyValue] = [
      "ar": "Arabic",
      "de": "German",
      "en": "English",
      "es": "Spanish",
      "fr": "French",
      "he": "Hebrew",
      "it": "Italian",
      "nl": "Dutch",
      "no": "Norwegian",
      "pt": "Portuguese",
      "ru": "Russian",
      "se": "Swedish",
      "zh": "Chinese"
    ].map { KeyValue(key: $0.key, value: $0.value) }
      .sorted()

    static let countries: [KeyValue] = {
      Locale.isoRegionCodes.reduce([:] as [String: String]) { array, code in
        var newArray = array
        if let name = Locale.current.localizedString(forRegionCode: code) {
          newArray[code] = name
        }
        return newArray
      }
    }().map { KeyValue(key: $0.key, value: $0.value) }
      .sorted()
  }
}

struct KeyValue: Equatable, Identifiable, Hashable, Comparable {
  let key: String
  let value: String
  var id: String { key }

  static func < (lhs: KeyValue, rhs: KeyValue) -> Bool {
    lhs.key < rhs.key
  }
}
