//
//  TagViewTest.swift
//  NewzTests
//
//  Created by MOUAD BENJRINIJA on 28/9/2022.
//

import XCTest
import ViewInspector
import SwiftUI
@testable import Newz

extension TagView: Inspectable { }
extension FlowLayout: Inspectable { }
extension TagCell: Inspectable { }

final class TagViewTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

  func test_noInput_emptyTags() throws {
    let input = Binding(wrappedValue: [String]())
    let expected = "title"
    let view = TagView(title: expected, tags: input)
    let sut = TagViewInspector(inspector: try view.inspect())
    let result = try sut.inputField
      .find(text: expected)
      .string()

    ViewHosting.host(view: view)

    XCTAssertEqual(result, expected)
    XCTAssertTrue(try sut.addButton.isDisabled())
  }

  func test_addClickWithValue_added() throws {
    let input = Binding(wrappedValue: [String]())
    let expected = "newValue"
    var result: String?
    var countResult: Int?
    let expectation = expectation(description: #function)
    var view = TagView(title: "title", tags: input)

    view.on(\.didAppear) { view in
      let sut = TagViewInspector(inspector: view)
      XCTAssertTrue(try sut.addButton.isDisabled())
      try sut.inputField.setInput(expected)
      XCTAssertTrue(try !sut.inputField.input().isEmpty)
      try sut.addButton.tap()
      XCTAssertTrue(try sut.inputField.input().isEmpty)

      result = try sut.tagViews.first?.find(text: expected).string()
      countResult = try sut.tagViews.count
      expectation.fulfill()
    }

    ViewHosting.host(view: view)
    wait(for: [expectation], timeout: 0.2)
    XCTAssertEqual(result, expected)
    XCTAssertEqual(countResult, 1)
  }

}

struct TagViewInspector {
  let inspector: InspectableView<ViewType.View<TagView>>

  var inputField: InspectableView<ViewType.TextField> {
    get throws {
      try inspector
        .vStack(0)
        .hStack(0)
        .textField(0)
    }
  }

  var addButton: InspectableView<ViewType.Button> {
    get throws {
      try inspector
        .vStack(0)
        .hStack(0)
        .button(1)
    }
  }

  var flowLayout: InspectableView<ViewType.View<FlowLayout<String, AnyView>>> {
    get throws {
      try inspector
        .vStack(0)
        .find(FlowLayout<String, AnyView>.self)
    }
  }

  var tagViews: InspectableView<ViewType.ForEach> {
    get throws {
      try flowLayout
        .geometryReader()
        .zStack()
        .forEach(0)
    }
  }
}
