//
//  Article.swift
//  Newz
//
//  Created by Mouad Bj on 14/9/2022.
//

import Foundation

// MARK: - Article
struct Article: Codable, Equatable, Identifiable {
  var id = UUID()
  let author, title, desc: String?
  let url: String?
  let source: String?
  let image: String?
  let category, language, country: String?
  let publishedAt: Date?

  enum CodingKeys: String, CodingKey {
    case author, title
    case desc = "description"
    case url, source, image, category, language, country
    case publishedAt = "published_at"
  }
}

extension Article: Comparable {
  static func < (lhs: Article, rhs: Article) -> Bool {
    return lhs.url! < rhs.url!
  }
}

extension Article {
  struct Criteria {
    var name: String
    var sources: [String]?
    var categories: [String]?
    var countries: [String]?
    var languages: [String]?
    var keywords: [String]?
    var mindDate: Date?
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
        "date": mindDate == nil ? nil : [mindDate, maxDate]
                  .compactMap {$0}.map {$0.string()}
                  .joined(separator: ","),
        "sort": sort?.rawValue,
        "limit": limit?.description,
        "offset": offset?.description
      ]
      return dic.compactMapValues { $0 }
    }
  }
  enum Sort: String {
    case publishedDesc = "published_desc"
    case publishedAsc = "published_asc"
    case popularity = "popularity"
  }
}
