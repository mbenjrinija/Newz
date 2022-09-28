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
