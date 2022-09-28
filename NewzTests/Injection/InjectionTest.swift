//
//  Injection.swift
//  NewzTests
//
//  Created by Mouad Bj on 22/9/2022.
//

import XCTest
@testable import Newz

final class Injection: XCTestCase {

  @Inject(.Repository.Db.articles) var sut: ArticlesDbRepository

  override func setUpWithError() throws {
    DIContainer.default.reset()
    DIContainer.default.register(.Provider.persistentStore) { _ in
      CoreDataStackMock()
    }
  }

  override func tearDownWithError() throws {
    DIContainer.default.reset()
  }

  func test_injection_success() throws {
    // Given
    DIContainer.default.register(.Repository.Db.articles) { injector in
      ArticlesDbRepoImpl(persistentStore:
                          try injector.resolve(.Provider.persistentStore))
    }
    // When: using the injected value
    // Then
    XCTAssertNotNil(sut)
  }

  func test_injection_failure() throws {
    // Given: No initial configuration
    DIContainer.default.reset()
    // When: Calling the injected value
    // Then
    XCTAssertThrowsError(try DIContainer.default.resolve(.Repository.Db.articles))
  }

}
