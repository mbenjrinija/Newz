//
//  CoreDateStack.swift
//  NewzTests
//
//  Created by Mouad Bj on 14/9/2022.
//

@testable import Newz
import XCTest
import Combine
import CoreData

final class TestCoreDataStack: XCTestCase {

  var sut: CoreDataStack!
  var subs = Set<AnyCancellable>()

  override func setUpWithError() throws {
    let storeDescription = NSPersistentStoreDescription()
    storeDescription.type = NSInMemoryStoreType
    sut = CoreDataStack(storeDescription: storeDescription)
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func test_initPersistentStore_loadedSuccess() throws {
    // Given
    let expected = true
    var result: Result<Bool, Error>?
    let expectation = expectation(description: #function)

    // When
    sut.isStoreLoaded
      .first(where: { $0 })
      .sinkToResult { value in
        result = value
        expectation.fulfill()
      }.store(in: &subs)

    wait(for: [expectation], timeout: 0.1)

    // Then
    result!.assertSuccess(to: expected)
  }

  func test_saveAndFetch_success() {
    // Given
    let expected = Article.stub
    let expectation = expectation(description: #function)
    var result: [Article]?

    sut.save(expected)
      .flatMap { _ in
        // When
        self.sut.fetch(Article.self) { Article.fetchRequest }
      }.sinkToResult { results in
        result = try? results.get()
        expectation.fulfill()
      }.store(in: &subs)

    wait(for: [expectation], timeout: 1)
    // Then
    XCTAssertEqual(result?.sorted(), expected.sorted(),
                   "\(#file) > \(#function) Data not saved correctly")
  }

}
