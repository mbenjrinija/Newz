//
//  HomeViewModel.swift
//  Newz
//
//  Created by Mouad Bj on 24/9/2022.
//

import Foundation
import Combine

extension HomeView {
  class ViewModel: ObservableObject {

    @Published var feedCriterias: [Article.Criteria] = Article.Criteria.stub
    @Published var selectedFeed = 0

    var subs = Set<AnyCancellable>()

    var titles: [String] {
      feedCriterias.map(\.name)
    }

  }

}
