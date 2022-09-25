//
//  ArticlesService.swift
//  Newz
//
//  Created by Mouad Bj on 22/9/2022.
//

import Foundation
import Combine

protocol ArticlesService {
  func loadLiveArticles(criteria: Article.Criteria) -> AnyPublisher<[Article], Error>
  func loadSavedArticles() -> AnyPublisher<[Article], Error>
}

struct ArticlesServiceImpl: ArticlesService {
  let persistentStore: ArticlesDbRepository
  let apiRepository: ArticlesApiRepository

  func loadLiveArticles(criteria: Article.Criteria) -> AnyPublisher<[Article], Error> {
    // apiRepository.fetchArticles(criteria: criteria)
    // temp mock result
    Future<[Article], Error> { promise in
      DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(4)) {
        let data = try? Article.loadJson(of: ArrayResult<Article>.self, for: .articles).data
        promise(.success(data ?? []))
      }
    }.eraseToAnyPublisher()
  }

  func loadSavedArticles() -> AnyPublisher<[Article], Error> {
    persistentStore.fetchArticles()
  }
}
