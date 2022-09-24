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

    @Inject(.Service.articles) var articlesService: ArticlesService

    @Published var articles: Loadable<ArrayResult<Article>> = .notLoaded
    @Published var criteria: Article.Criteria = Article.Criteria()

    var subs = Set<AnyCancellable>()

    func loadArticles() {
      articlesService.loadLiveArticles(criteria: criteria)
        .assignTo(bindingOf(loadable: \.articles))
    }
  }
}
