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

struct ArticlesServiceMain: ArticlesService {
  let persistentStore: ArticlesDbRepository
  let apiRepository: ArticlesApiRepository

  func loadLiveArticles(criteria: ArticleCriteria) -> AnyPublisher<[Article], Error> {
     apiRepository.fetchArticles(criteria: criteria)
      .map { $0.data }
      .replaceNil(with: [])
      .eraseToAnyPublisher()
  }

  func loadSavedArticles() -> AnyPublisher<[Article], Error> {
    persistentStore.fetchArticles()
  }
}

struct ArticlesServiceOfflineStub: ArticlesService {
  let persistentStore: ArticlesDbRepository
  func loadLiveArticles(criteria: ArticleCriteria) -> AnyPublisher<[Article], Error> {
    Future<[Article], Error> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
        //promise(.success(Article.stub.shuffled()))
        promise(.success(Article.stub))
      }
    }.eraseToAnyPublisher()
  }

  func loadSavedArticles() -> AnyPublisher<[Article], Error> {
    persistentStore.fetchArticles()
  }
}
