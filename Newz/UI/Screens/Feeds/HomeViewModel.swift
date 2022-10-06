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

    @Inject(.Service.criterias) var criteriasService
    @Published var feedsCriterias: [ArticleCriteria] = []
    @Published var selectedFeed: String?

    var subs = CancelBag()

    var titles: [String] {
      feedsCriterias.map(\.name).map { $0 ?? "Untitled" }
    }

    var feeds: [FeedViewModel] {
      feedsCriterias.enumerated()
        .map { FeedViewModel(criteria: $1, tag: $0) }
    }

    func configure() {
      criteriasService.loadCriterias()
        .receive(on: DispatchQueue.main)
        .replaceError(with: []) // TODO: handle error
        .sink(receiveValue: { [weak self] value in
          self?.feedsCriterias = value
          self?.selectedFeed = value.first?.name
        }).store(in: &subs)
    }
  }

}
