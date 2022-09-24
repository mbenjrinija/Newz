//
//  Date+Extension.swift
//  Newz
//
//  Created by Mouad Bj on 23/9/2022.
//

import Foundation

extension Date {
  enum Format: String {
    case normal = "yyyy-MM-dd"
  }

  func string(_ format: Format = .normal) -> String {
    self.format(with: format.rawValue)
  }

  func format(with format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
}
