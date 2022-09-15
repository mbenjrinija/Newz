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

  var dataStack: CoreDataTestStack!
  var subs = Set<AnyCancellable>()

  override func setUpWithError() throws {
    dataStack = CoreDataTestStack()
  }

  override func tearDownWithError() throws {
    dataStack = nil
  }

  func test_InitStack_StoreLoaded() throws {
    // Given
    let expected = true
    var result: Result<Bool, Error>?
    let expectation = expectation(description: #function)

    // When
    dataStack.isStoreLoaded
      .first(where: { $0 })
      .sinkToResult { value in
        result = value
        expectation.fulfill()
      }.store(in: &subs)

    wait(for: [expectation], timeout: 0.1)

    // Then
    result!.assertSuccess(to: expected)
  }
  
}

class CoreDataTestStack: CoreDataStack {
  override func configureContainer() {
    let storeDescription = NSPersistentStoreDescription()
    storeDescription.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [storeDescription]
  }
}
