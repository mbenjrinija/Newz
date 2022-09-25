//
//  FeedPager.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 25/9/2022.
//

import SwiftUI
import Combine

struct FeedPager: View {
  @Binding var selected: Int
  @StateObject var viewModel: ViewModel

  init(feedCriterias: [Article.Criteria], selected: Binding<Int>) {
    self._selected = selected
    self._viewModel = StateObject(wrappedValue:
                                    ViewModel(feedCriterias: feedCriterias))
  }

  var body: some View {
    TabView(selection: $selected) {
      ForEach(Array(viewModel.feeds.enumerated()),
              id: \.offset) { index, feed in
        FeedView(viewModel: feed).tag(index)
      }
    }.tabViewStyle(.page(indexDisplayMode: .never))
  }
}

extension FeedPager {
  class ViewModel: ObservableObject {
    @Published var feeds: [FeedViewModel]

    init(feedCriterias: [Article.Criteria]) {
      self.feeds = feedCriterias.map { FeedViewModel(criteria: $0) }
    }
  }
}

struct FeedPager_Previews: PreviewProvider {
    static var previews: some View {
      FeedPager(feedCriterias: Article.Criteria.stub, selected: .constant(1))
    }
}
