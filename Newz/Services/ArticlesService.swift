//
//  ArticlesService.swift
//  Newz
//
//  Created by Mouad Bj on 22/9/2022.
//

import Foundation
import Combine

protocol ArticlesService {
  func loadLiveArticles(criteria: ArticleCriteria) -> AnyPublisher<[Article], Error>
  func loadSavedArticles() -> AnyPublisher<[Article], Error>
}

struct ArticlesServiceImpl: ArticlesService {
  let persistentStore: ArticlesDbRepository
  let apiRepository: ArticlesApiRepository

  func loadLiveArticles(criteria: ArticleCriteria) -> AnyPublisher<[Article], Error> {
//     apiRepository.fetchArticles(criteria: criteria)
//      .map { $0.data }
//      .replaceNil(with: [])
//      .eraseToAnyPublisher()
    // temp mock result
    Future<[Article], Error> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
        let data = try? Article.loadJson(of: ArrayResult<Article>.self, for: .articles).data
        promise(.success(data ?? []))
      }
    }.eraseToAnyPublisher()
  }

  func loadSavedArticles() -> AnyPublisher<[Article], Error> {
    persistentStore.fetchArticles()
  }
}
