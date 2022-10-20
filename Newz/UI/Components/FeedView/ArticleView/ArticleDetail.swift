//
//  ArticleDetail.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 10/10/2022.
//

import SwiftUI

struct ArticleDetail: View {
  @Binding var selected: ArticleItem.Payload?
  @GestureState var scaleDown: CGFloat = 1
  @Environment(\.showHomeToolBar) var showHomeToolBar

  // We want to have both views in the same time (list item and details view)
  // one way we can do so is by interchanging namespaces
  // the list item view will be the source in the matched geo effect

  // activeNamespace will take one of two values, either dummy or parent
  @State var activeNamespace: Namespace.ID?
  // dummyNamespace will be active when the view must take it's original position
  @Namespace var dummyNamespace
  // the parentNamespace will be active when the view must take the parent position
  var parentNamespace: Namespace.ID?

  var isActive: Bool {
    activeNamespace == dummyNamespace
  }

  init(selected: Binding<ArticleItem.Payload?>, namespace: Namespace.ID? = nil) {
    self._selected = selected
    self.parentNamespace = namespace
    self._activeNamespace = State(initialValue: namespace)
  }
  var body: some View {
    if let selected {
      GeometryReader { geometry in
        ArticleItem(payload: selected, showDetails: isActive, namespace: activeNamespace)
          .scaleEffect(isActive ? scaleDown : 1)
        .gesture(dragDownGesture(height: geometry.size.height))
      }
      .background(BackgroundBlurView(
        effect: .systemMaterialDark,
        opacity: isActive ? 1 : 0)
      )
      .ignoresSafeArea(.all)
      .onAppear {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
          activeNamespace = dummyNamespace
          showHomeToolBar.wrappedValue = false
        }
      }
    }
  }

  func dragDownGesture(height: CGFloat) -> some Gesture {
    DragGesture()
      .updating($scaleDown, body: { gesture, state, _ in
        let scale = 1 - (gesture.translation.height / height)
        if scale > 0.8, scale <= 1 && isActive {
          state = scale
          if scale < 0.9 {
            DispatchQueue.main.async {
              withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                activeNamespace = parentNamespace
              }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
              selected = nil
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
              withAnimation {
                showHomeToolBar.wrappedValue = true
              }
            }
          }
        }
      })
  }

}

struct ArticleDetail_Previews: PreviewProvider {
  static var previews: some View {
    Parent()
  }

  struct Parent: View {
    @Namespace var namespace
    var body: some View {
      ArticleDetail(selected: .constant(.init(article: Article.stub.first!)),
                      namespace: namespace)
    }
  }

}
