//
//  StubTest.swift
//  NewzTests
//
//  Created by Mouad Bj on 21/9/2022.
//

import XCTest
@testable import Newz

final class StubTest: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func test_loadJson_success() throws {
    // Given
    let jsonName = StubFile.articles

    // When
    let articles = StubDummy.loadJson(of: ArrayResult<Article>.self, for: jsonName)?.data ?? []

    // Then
    XCTAssertTrue(articles.count > 0)
  }

  func test_loadWrongJson_failure() throws {
    // Given
    let wrongJsonName = StubFile.nonExistent

    // When
    let articles = StubDummy.loadJson(of: ArrayResult<Article>.self, for: wrongJsonName)?.data

    // Then
    XCTAssertTrue(articles == nil)
  }

  func test_loadJsonWrongObject_failure() throws {
    // Given
    let jsonName = StubFile.articles

    // When
    let articles = StubDummy.loadJson(of: [Article].self, for: jsonName)

    // Then
    XCTAssertTrue(articles == nil)
  }

}

struct StubDummy: Stub {
  static var stub: [StubDummy] = []
}
