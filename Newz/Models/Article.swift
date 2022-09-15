//
//  Article.swift
//  Newz
//
//  Created by Mouad Bj on 14/9/2022.
//

import Foundation

// MARK: - ArrayResult
struct ArrayResult<T: Codable>: Codable {
  let pagination: Pagination?
  let data: [T]?
}

// MARK: - Datum
struct Article: Codable {
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

// MARK: - Pagination
struct Pagination: Codable {
  let limit, offset, count, total: Int?
}
