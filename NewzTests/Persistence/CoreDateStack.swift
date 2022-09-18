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

  var persistentStore: CoreDataTestStack!
  var subs = Set<AnyCancellable>()

  override func setUpWithError() throws {
    persistentStore = CoreDataTestStack()
  }

  override func tearDownWithError() throws {
    persistentStore = nil
  }

  func test_InitStack_StoreLoaded() throws {
    // Given
    let expected = true
    var result: Result<Bool, Error>?
    let expectation = expectation(description: #function)

    // When
    persistentStore.isStoreLoaded
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
    let expected = Article.mock
    let expectation = expectation(description: #function)
    var result: [Article]?

    persistentStore.save(expected)
      .sinkToResult {[weak self] _ in
        guard let self = self else { return }
        // When
        self.persistentStore.fetch(Article.self) {
          Article.fetchRequest
        }.sinkToResult { results in
          result = try? results.get()
          expectation.fulfill()
        }.store(in: &(self.subs))
      }.store(in: &subs)

    wait(for: [expectation], timeout: 1)
    // Then
    XCTAssertEqual(result?.sorted(), expected.sorted(),
                   "\(#file) > \(#function) Data not saved correctly")
  }

}

class CoreDataTestStack: CoreDataStack {
  override func configureContainer() {
    let storeDescription = NSPersistentStoreDescription()
    storeDescription.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [storeDescription]
  }
}
