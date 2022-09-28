//
//  Feed.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 24/9/2022.
//

import Foundation

final class FeedViewModel: ObservableObject, Identifiable {

  @Inject(.Service.articles) var articlesService: ArticlesService

  var criteria: ArticleCriteria
  var tag: Int
  @Published var articles: Loadable<[Article]>

  init(criteria: ArticleCriteria, tag: Int,
       articles: Loadable<[Article]> = .notLoaded) {
    self.criteria = criteria
    self.tag = tag
    self.articles = articles
  }

  func configure() {
    if case .notLoaded = articles {
      articlesService.loadLiveArticles(criteria: criteria)
        .assignTo(bindingOf(loadable: \.articles))
    }
  }
}
