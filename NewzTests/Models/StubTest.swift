//
//  StubTest.swift
//  NewzTests
//
//  Created by Mouad Bj on 21/9/2022.
//

import XCTest
@testable import Newz

final class StubTest: XCTestCase {

  func test_loadJson_success() throws {
    // Given
    let jsonName = StubFile.articles
    // When
    let articles = try StubDummy.loadJson(of: ArrayResult<Article>.self, for: jsonName).data ?? []
    // Then
    XCTAssertTrue(articles.count > 0)
  }

  func test_loadWrongJson_failure() throws {
    // Given
    let wrongJsonName = StubFile.nonExistent
    // Then
    XCTAssertThrowsError(try StubDummy.loadJson(of: ArrayResult<Article>.self,
                                                for: wrongJsonName))
  }

}

struct StubDummy: Stub {
  static var stub: [StubDummy] = []
}
