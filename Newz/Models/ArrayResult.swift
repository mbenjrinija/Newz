//
//  ArrayResult.swift
//  Newz
//
//  Created by Mouad Bj on 23/9/2022.
//

import Foundation

// MARK: - ArrayResult
struct ArrayResult<T: Equatable & Codable>: Codable, Equatable {
  static func == (lhs: ArrayResult<T>, rhs: ArrayResult<T>) -> Bool {
    lhs.data == rhs.data && lhs.pagination == rhs.pagination
  }

  let pagination: Pagination?
  let data: [T]?
}

// MARK: - Pagination
struct Pagination: Codable, Equatable {
  let limit, offset, count, total: Int?
}
