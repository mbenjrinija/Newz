//
//  ArrayResult.swift
//  Newz
//
//  Created by Mouad Bj on 23/9/2022.
//

import Foundation

// MARK: - ArrayResult
struct ArrayResult<T: Codable>: Codable {
  let pagination: Pagination?
  let data: [T]?
}

// MARK: - Pagination
struct Pagination: Codable {
  let limit, offset, count, total: Int?
}
