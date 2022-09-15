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

    func test_InitStack_StoreLoaded() async throws {
        // Given
        let expected = true
        var result: Result<Bool, Error>?
        let expectation = expectation(description: #function)

        // When
        dataStack.isStoreLoaded
            .sinkToResult { value in
                result = value
            }.store(in: &subs)

        wait(for: [expectation], timeout: 1)

        // Then
        result!.assertSuccess(to: expected)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class CoreDataTestStack: CoreDataStack {
    override func configureContainer() {
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [storeDescription]
    }
}

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Self.Output, Self.Failure>) -> Void ) -> AnyCancellable {
        self.sink { completion in
            if case .failure(let error) = completion {
                result(.failure(error))
            }
        } receiveValue: { value in
            result(.success(value))
        }
    }
}

extension Result where Success: Equatable {
    func assertSuccess(to expectedValue: Success, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case .success(let result):
            XCTAssertEqual(result, expectedValue, file: file, line: line)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
}
