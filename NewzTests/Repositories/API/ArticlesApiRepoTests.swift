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

  let fakeBaseUrl = "https://fake.url"
  var sut: ArticlesApiRepoImpl!
  var subs = Set<AnyCancellable>()

  override func setUpWithError() throws {
    sut = ArticlesApiRepoImpl(session: .mocked)
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func test_fetchArticles() throws {
    // Given
    let expectation = expectation(description: "Fetching articles")
    let expected = Article.stub
    var results: [Article]?
    let call = ArticlesApiRepoImpl.API.getArticles

    let mockResponse = MockResponse(
      url: try XCTUnwrap(try? call.request(baseURL: ArticlesApiRepoImpl.baseUrl).url?.absoluteString),
      result: .success(StubDummy.loadData(for: .articles)!))
    MockUrlProtocol.mockResponses.append(mockResponse)
    // When
    sut.fetchArticles()
      .sinkToResult { result in
        result.assertSuccess()
        results = try? result.get()
        expectation.fulfill()
      }.store(in: &subs)
    wait(for: [expectation], timeout: 4)

    // Then
    XCTAssertEqual(try XCTUnwrap(results), expected)
  }

}
