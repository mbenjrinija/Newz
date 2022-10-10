//
//  Feed.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 24/9/2022.
//

import Foundation
import SwiftUI

final class FeedViewModel: ObservableObject, Identifiable {

  @Inject(.Service.articles) var articlesService: ArticlesService
  @Inject(.Service.images) var imageService: ImageService
  var criteria: ArticleCriteria
  var tag: Int
  var subs = CancelBag()
  @Published var articles: Loadable<[Article]>
  @Published var selectedArticle: ArticleItem.Payload?

  init(criteria: ArticleCriteria, tag: Int,
       articles: Loadable<[Article]> = .notLoaded) {
    self.criteria = criteria
    self.tag = tag
    self.articles = articles
  }

  func configure() {
    if case .notLoaded = articles {
      loadArticles()
    }
  }

  func loadArticles() {
    articlesService.loadLiveArticles(criteria: criteria)
      .assignTo(bindingOf(loadable: \.articles))
  }

  func expand(_ article: Article) {
    if let stringUrl = article.image, let url = URL(string: stringUrl) {
      imageService
        .loadImage(from: url)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: {_ in }, receiveValue: { image in
          self.selectedArticle = .init(image: image, article: article)
        }).store(in: &subs)
    }
  }

  func cellConfig(for article: Article) -> ArticleItem.Payload {
    if let selected = selectedArticle,
        let image = selected.image,
       article.url == selected.article.url {
      return .init(image: image, article: article)
    }
    return .init(article: article)
  }

  func transitionConfig(for article: Article) async -> ArticleItem.Payload {
    if let stringUrl = article.image, let url = URL(string: stringUrl) {
      let image = try? await imageService.loadImage(from: url).async()
      return .init(image: image, article: article, expanded: true)
    }
    return .init(article: article, expanded: true)
  }

  func expand(with config: ArticleItem.Payload) {
    self.selectedArticle = config
  }

  func collapseArticle() {
    selectedArticle = nil
  }
}
