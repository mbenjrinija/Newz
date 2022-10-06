//
//  FeedPager.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 25/9/2022.
//

import SwiftUI
import Combine

struct FeedPager: View {
  @State var viewModel: ViewModel
  @Binding var feedsCriterias: [ArticleCriteria]
  @Binding var selected: String?

  init(feedsCriterias: Binding<[ArticleCriteria]>,
       selected: Binding<String?>) {
    self._feedsCriterias = feedsCriterias
    self._selected = selected
    let viewModel = ViewModel(feedsCriterias: feedsCriterias.wrappedValue)
    self._viewModel = State(initialValue: viewModel)
  }

  var body: some View {
    TabView(selection: $selected) {
      ForEach(viewModel.feeds) { feed in
        FeedView(viewModel: feed).tag(feed.criteria.name)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .onChange(of: feedsCriterias, perform: { newCriterias in
      viewModel.update(feedsCriterias: newCriterias)
    })
  }
}

extension FeedPager {
  struct ViewModel {
    var feeds: [FeedViewModel]

    init(feedsCriterias: [ArticleCriteria]) {
      self.feeds = Self.models(from: feedsCriterias)
    }

    mutating func update(feedsCriterias: [ArticleCriteria]) {
      self.feeds = Self.models(from: feedsCriterias)
    }

    static func models(from feedsCriterias: [ArticleCriteria])
        -> [FeedViewModel] {
      feedsCriterias.enumerated()
        .map { FeedViewModel(criteria: $1, tag: $0) }
    }
  }
}

struct FeedPager_Previews: PreviewProvider {
    static var previews: some View {
      FeedPager(feedsCriterias: .constant(ArticleCriteria.stub), selected: .constant(ArticleCriteria.stub.first?.name))
    }
}
