//
//  ArticleExpanded.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 10/10/2022.
//

import SwiftUI

struct ArticleExpanded: View {
  @Binding var selected: ArticleItem.Payload?
  @State var scale: CGFloat = 1
  var namespace: Namespace.ID
  var body: some View {
    if let selected {
      GeometryReader { geometry in
        ScrollView {
          Group {
            ArticleItem(payload: selected,
                        namespace: namespace)
            .frame(height: geometry.size.height)
            .gesture(DragGesture(minimumDistance: 0)
              .onChanged { value in
                isDraggingSelectedArticle(by: value.translation.height,
                                             outOf: geometry.size.height)
              }.onEnded { _ in
                resetScale()
              }
            )
          }
        }
      }
      .scaleEffect(scale)
      .ignoresSafeArea(.all)
    }
  }

  func isDraggingSelectedArticle(by distance: CGFloat, outOf height: CGFloat) {
    let scale = 1 - (distance / height)
    if scale > 0.8, scale <= 1 {
      DispatchQueue.main.async {
        print(scale)
        if scale < 0.9 {
          withAnimation(.spring()) {
            self.selected = nil
          }
        } else {
          self.scale = scale
        }
      }
    }
  }

  func resetScale() {
    self.scale = 1
  }

}

struct ArticleExpanded_Previews: PreviewProvider {
  static var previews: some View {
    Parent()
  }

  struct Parent: View {
    @Namespace var namespace
    var body: some View {
      ArticleExpanded(selected: .constant(.init(article: Article.stub.first!)),
                      namespace: namespace)
    }
  }

}
