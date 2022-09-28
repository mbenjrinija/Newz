//
//  ArticleCriteria.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 27/9/2022.
//

import Foundation

struct ArticleCriteria: Identifiable, Equatable {
  var id = UUID()
  var name: String?
  var sources: [String]?
  var categories: [String]?
  var countries: [String]?
  var languages: [String]?
  var keywords: [String]?
  var minDate: Date?
  var maxDate: Date?
  var sort: Sort?
  var limit: Int?
  var offset: Int?

  func toDictionnary() -> [String: String] {
    let dic: [String: String?] = [
      "sources": sources?.joined(separator: ","),
      "categories": categories?.joined(separator: ","),
      "countries": countries?.joined(separator: ","),
      "languages": languages?.joined(separator: ","),
      "keywords": keywords?.joined(separator: ","),
      "date": minDate == nil ? nil : [minDate, maxDate]
                .compactMap {$0}.map {$0.string()}
                .joined(separator: ","),
      "sort": sort?.rawValue,
      "limit": limit?.description,
      "offset": offset?.description
    ]
    return dic.compactMapValues { $0 }
  }

  enum Sort: String {
    case publishedDesc = "published_desc"
    case publishedAsc = "published_asc"
    case popularity = "popularity"
  }
}
