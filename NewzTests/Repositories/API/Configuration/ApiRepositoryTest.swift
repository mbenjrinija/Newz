//
//  ApiRepositoryTest.swift
//  NewzTests
//
//  Created by Mouad Bj on 22/9/2022.
//

import XCTest
import Combine
@testable import Newz

final class ApiRepositoryTests: XCTestCase {

  var sut: TestApiRepository!
  var subs: Set<AnyCancellable>!

  override func setUp() {
    subs = Set<AnyCancellable>()
    sut = TestApiRepository()
  }

  override func tearDown() {
    MockUrlProtocol.reset()
  }

  func test_call_successful() throws {
    // Given
    let call = TestApiRepository.Call.success
    let expected = TestApiRepository.Model()
    let url = TestApiRepository.baseUrl + call.path
    let response = MockResponse.init(url: url, result:
        .success(try JSONEncoder().encode(expected)))
    MockUrlProtocol.register(mock: response)
    var results: Result<TestApiRepository.Model, Error>?
    let expectation = expectation(description: #function)

    // When
    sut.load(call: call)
      .sinkToResult { result in
        XCTAssertTrue(Thread.isMainThread)
        result.assertSuccess()
        results = result
        expectation.fulfill()
      }.store(in: &subs)
    wait(for: [expectation], timeout: 1)

    // Then
    (try XCTUnwrap(results)).assertSuccess(to: expected)
  }

  func test_wrongUrl_failure() throws {
    // Given
    let call = TestApiRepository.Call.urlError
    let expected = TestApiRepository.Model()
    let url = TestApiRepository.baseUrl + call.path
    let response = MockResponse.init(url: url, result:
        .success(try JSONEncoder().encode(expected)))
    MockUrlProtocol.register(mock: response)
    var results: Result<TestApiRepository.Model, Error>?
    let expectation = expectation(description: #function)

    // When
    sut.load(call: call)
      .sinkToResult { result in
        XCTAssertTrue(Thread.isMainThread)
        results = result
        expectation.fulfill()
      }.store(in: &subs)
    wait(for: [expectation], timeout: 1)

    // Then
    (try XCTUnwrap(results)).assertFailure(APIError.invalidURL)
  }

  func test_bodyError_failure() throws {
    // Given
    let call = TestApiRepository.Call.bodyError
    let expected = TestApiRepository.Model()
    let url = TestApiRepository.baseUrl + call.path
    let response = MockResponse.init(url: url, result:
        .success(try JSONEncoder().encode(expected)))
    MockUrlProtocol.register(mock: response)
    var results: Result<TestApiRepository.Model, Error>?
    let expectation = expectation(description: #function)

    // When
    sut.load(call: call)
      .sinkToResult { result in
        XCTAssertTrue(Thread.isMainThread)
        results = result
        expectation.fulfill()
      }.store(in: &subs)
    wait(for: [expectation], timeout: 1)

    // Then
    (try XCTUnwrap(results)).assertFailure(TestApiRepository.APIError.fail)
  }

  func test_noCodeError_failure() throws {
    // Given
    let call = TestApiRepository.Call.noHttpCodeError
    let expected = TestApiRepository.Model()
    let url = TestApiRepository.baseUrl + call.path
    let urlResponse = URLResponse(url: URL(fileURLWithPath: ""),
                                  mimeType: "example",
                                  expectedContentLength: 0,
                                  textEncodingName: nil)
    let response = MockResponse.init(url: url, result:
        .success(try JSONEncoder().encode(expected)), response: urlResponse)
    MockUrlProtocol.register(mock: response)
    var results: Result<TestApiRepository.Model, Error>?
    let expectation = expectation(description: #function)

    // When
    sut.load(call: call)
      .sinkToResult { result in
        XCTAssertTrue(Thread.isMainThread)
        results = result
        expectation.fulfill()
      }.store(in: &subs)
    wait(for: [expectation], timeout: 1)

    // Then
    (try XCTUnwrap(results)).assertFailure(APIError.unexpectedResponse)
  }

  func test_getApiKey_success() {
    let apiKey = try? TestApiRepository.apiKey
    XCTAssertNotNil(apiKey)
  }
}

class TestApiRepository: ApiRepository {
  var session: URLSession = .mocked

  func load(call: Call) -> AnyPublisher<Model, Error> {
    self.call(endpoint: call).eraseToAnyPublisher()
  }

  enum Call: APICall {
    case success
    case urlError
    case bodyError
    case noHttpCodeError

    var path: String {
      if self == .urlError { return "くそ" } // kuso
      return "/test/path"
    }
    var method: String { "POST" }
    var headers: [String: String]? { nil }
    func body() throws -> Data? {
      if self == .bodyError { throw APIError.fail }
      return nil
    }
  }

  enum APIError: Swift.Error, LocalizedError {
    case fail
    var errorDescription: String? { "fail" }
  }

  struct Model: Codable, Equatable {
    var text: String?
    var number: Int?
    init() {
      text = "text"
      number = 123
    }
  }
}
