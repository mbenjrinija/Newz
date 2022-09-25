//
//  Feed.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 24/9/2022.
//

import Foundation

final class FeedViewModel: ObservableObject, Identifiable {

  @Inject(.Service.articles) var articlesService: ArticlesService

  @Published var criteria: Article.Criteria
  @Published var articles: Loadable<[Article]>

  init(criteria: Article.Criteria,
       articles: Loadable<[Article]> = .notLoaded) {
    self.criteria = criteria
    self.articles = articles
  }

  func configure() {
    if case .notLoaded = articles {
      articlesService.loadLiveArticles(criteria: criteria)
        .assignTo(bindingOf(loadable: \.articles))
    }
  }
}
