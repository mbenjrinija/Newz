//
//  FeedTabs.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 25/9/2022.
//

import SwiftUI

struct FeedTabs: View {
  let titles: [String]
  @Binding var selected: String?
  @Namespace var namespace

  var body: some View {
      ScrollViewReader { scrollProxy in
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(titles, id: \.self) { title in
              TabItem(title: title,
                      selected: $selected,
                      namespace: namespace).id(title)
            }
          }
        }
        .onChange(of: selected, perform: { index in
          withAnimation {
            scrollProxy.scrollTo(index) // LEAK HERE
          }
        })
      }
  }
}

struct TabItem: View {
  var title: String
  @Binding var selected: String?
  var namespace: Namespace.ID

  var body: some View {
    let highlighted = selected == title
    return Button(action: { selected = title}, label: {
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
    }).animation(.spring(response: 0.3, dampingFraction: 0.6),
                 value: selected)
  }
}

struct FeedTabs_Previews: PreviewProvider {
  static var previews: some View {
    ParentView()
  }

  struct ParentView: View {
    static let titles = ["Headlines", "Apple", "Microsoft",
                  "Technology", "Block Chain", "Other"]
    @State var selected = titles.first
    var body: some View {
      FeedTabs(titles: Self.titles,
               selected: $selected)
    }
  }
}
