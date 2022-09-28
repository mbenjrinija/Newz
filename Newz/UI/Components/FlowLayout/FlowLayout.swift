//
//  FlowLayout.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 27/9/2022.
//

import SwiftUI

struct FlowLayout<T: Hashable, Content: View>: View {

  var items: [T]
  let viewMapping: (T) -> Content
  @State var height: CGFloat = .zero
  var body: some View {
    return GeometryReader { geometry in
      content(in: geometry)
    }.frame(height: height)
      .animation(.linear, value: height)
  }

  private func content(in geometry: GeometryProxy) -> some View {
    var hOffset = CGFloat.zero
    var vOffset = CGFloat.zero

    func horizontalOffset(for item: T, dim: ViewDimensions) -> CGFloat {
      if abs(hOffset - dim.width) > geometry.size.width {
        hOffset = 0
        vOffset -= dim.height
      }
      let result = hOffset
      if item == self.items.last {
        hOffset = 0
      } else {
        hOffset -= dim.width
      }
      return result
    }

    func verticalOffset(for item: T, dim: ViewDimensions) -> CGFloat {
      let result = vOffset
      if item == self.items.last {
        DispatchQueue.main.async {
          self.height = abs(result) + dim.height
        }
        vOffset = 0
      }
      return result
    }

    return ZStack(alignment: .topLeading) {
      ForEach(items, id: \.self) { item in
        viewMapping(item)
          .alignmentGuide(.leading, computeValue: { horizontalOffset(for: item, dim: $0) })
          .alignmentGuide(.top, computeValue: { verticalOffset(for: item, dim: $0) })
      }
    }
  }
}

struct FlowLayout_Previews: PreviewProvider {
  static var previews: some View {
    Parent()
  }
  struct Parent: View {
    @State var keywords = (0...10).map { "item \($0)" }
    var body: some View {
      FlowLayout(items: keywords) { item in
        Text(item)
      }
    }
  }
}
