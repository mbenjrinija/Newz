//
//  ArticlesApiRepoTests.swift
//  NewzTests
//
//  Created by Mouad Bj on 19/9/2022.
//

import XCTest
import Combine
@testable import Newz

final class ArticlesApiRepoTests: XCTestCase {

  var sut: ArticlesApiRepoImpl!
  var subs = Set<AnyCancellable>()

  override func setUpWithError() throws {
    sut = ArticlesApiRepoImpl(session: .mocked)
  }

  override func tearDownWithError() throws {
    sut = nil
    MockUrlProtocol.reset()
  }

  func test_fetchArticles() throws {
    // Given
    let expectation = expectation(description: "Fetching articles")
    let expected = Article.stub
    let criteria = ArticleCriteria()
    var results: [Article]?
    let call = ArticlesApiRepoImpl.Call.getArticles(criteria)

    let mockResponse = MockResponse(
      url: try XCTUnwrap(try? call.request().url?.absoluteString),
      result: .success(try StubDummy.loadData(for: .articles)))
    MockUrlProtocol.register(mock: mockResponse)
    // When
    sut.fetchArticles(criteria: criteria)
      .sinkToResult { result in
        result.assertSuccess()
        results = (try? result.get())?.data
        expectation.fulfill()
      }.store(in: &subs)
    wait(for: [expectation], timeout: 4)

    // Then
    XCTAssertEqual(try XCTUnwrap(results), expected)
  }

}
