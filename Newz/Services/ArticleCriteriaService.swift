//
//  ArticleCriteriaService.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 27/9/2022.
//

import Foundation
import Combine

protocol ArticleCriteriaService {
  func loadCriterias() -> AnyPublisher<[ArticleCriteria], Error>
  func save(criterias: [ArticleCriteria]) -> AnyPublisher<[ArticleCriteria], Error>
}

struct ArticleCriteriaServiceImpl: ArticleCriteriaService {
  let persistentStore: ArticleCriteriaDbRepository

  func loadCriterias() -> AnyPublisher<[ArticleCriteria], Error> {
    persistentStore.fetchArticleCriterias()
  }

  func save(criterias: [ArticleCriteria]) -> AnyPublisher<[ArticleCriteria], Error> {
    persistentStore
      .deleteAll()
      .flatMap { _ in
        persistentStore
          .save(criterias: criterias)
      }.eraseToAnyPublisher()
  }

}
