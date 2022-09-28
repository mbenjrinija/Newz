//
//  ArticlesDbRepoTests.swift
//  NewzTests
//
//  Created by Mouad Bj on 19/9/2022.
//

@testable import Newz
import XCTest
import Combine

final class TestArticlesDbRepo: XCTestCase {

  var sut: ArticlesDbRepository!
  var mockDataStack: CoreDataStackMock!
  var subs = Set<AnyCancellable>()

  override func setUpWithError() throws {
    mockDataStack = CoreDataStackMock()
    sut = ArticlesDbRepoImpl(persistentStore: mockDataStack)
  }

  override func tearDownWithError() throws {
    sut = nil
    mockDataStack = nil
  }

  func test_saveArticle_success() throws {
    // Given
    let stub = Article.stub
    var results: [Article]?
    mockDataStack.recorder = .init(expected: [
      .insert("\(Article.self)", .init(inserted: stub.count, updated: 0, deleted: 0))
    ])
    let expectation = expectation(description: #function)

    // When
    sut.save(articles: stub)
      .sinkToResult { result in
        result.assertSuccess()
        results = try? result.get()
        expectation.fulfill()
      }.store(in: &subs)
    wait(for: [expectation], timeout: 0.1)

    // Then
    mockDataStack.verify()
    XCTAssertEqual(results!.count, stub.count, "Result count doesn't match")
  }

  func test_fetchArticles_success() throws {
    // Given
    let stub = Article.stub
    var results: [Article]?
    try mockDataStack.preload(stub)
    mockDataStack.recorder = .init(expected: [
      .fetch("\(Article.self)", .init(inserted: 0, updated: 0, deleted: 0))
    ])
    let expectations = expectation(description: #function)

    // When
    sut.fetchArticles()
      .sinkToResult { result in
        result.assertSuccess()
        results = try? result.get()
        expectations.fulfill()
      }.store(in: &subs)
    wait(for: [expectations], timeout: 0.1)

    // Then
    mockDataStack.verify()
    XCTAssertEqual(results!.count, stub.count, "Result count doesn't match")
  }

}
