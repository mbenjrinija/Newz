//
//  FeedTabs.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 25/9/2022.
//

import SwiftUI

struct FeedTabs: View {

  let titles: [String]
  @Binding var selected: Int
  @Namespace var namespace

  var body: some View {
      ScrollView(.horizontal, showsIndicators: false) {
        ScrollViewReader { proxy in
          HStack {
            ForEach(Array(titles.enumerated()),
                    id: \.element) { index, title in
              tabItem(title: title,
                      tag: index)
                      .id(index)
            }
          }.animation(.spring(response: 0.3, dampingFraction: 0.6),
                      value: selected)
           .onChange(of: selected, perform: { index in
             withAnimation {
               proxy.scrollTo(index)
             }
           })
        }
      }
  }

  func tabItem(title: String, tag: Int) -> some View {
    let highlighted = selected == tag
    return Button(action: { selected = tag}, label: {
      VStack(spacing: 8) {
        Text(title)
          .font(.title3)
          .fontWeight(highlighted ? .bold : .medium)
          .foregroundColor(highlighted ? .blue : .gray)
        if highlighted {
          Color.blue.frame(height: 3)
            .matchedGeometryEffect(id: "tab_underline", in: namespace)
        }
      }.padding(.horizontal)
    })
  }
}

struct FeedTabs_Previews: PreviewProvider {
  static var previews: some View {
    ParentView()
  }

  struct ParentView: View {
    @State var selected = 1
    var body: some View {
      FeedTabs(titles: ["Headlines", "Apple", "Microsoft",
                        "Technology", "Block Chain", "Other"],
               selected: $selected)
    }
  }
}
