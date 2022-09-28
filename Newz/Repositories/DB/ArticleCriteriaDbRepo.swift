//
//  ArticleCriteriaDbRepo.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 27/9/2022.
//

import Foundation
import Combine

protocol ArticleCriteriaDbRepository {
  func save(criterias: [ArticleCriteria]) -> AnyPublisher<[ArticleCriteria], Error>
  func fetchArticleCriterias() -> AnyPublisher<[ArticleCriteria], Error>
  func deleteAll() -> AnyPublisher<[ArticleCriteria], Error>
}

struct ArticleCriteriaDbRepoImpl: ArticleCriteriaDbRepository {

  let persistentStore: PersistentStore

  func save(criterias: [ArticleCriteria]) -> AnyPublisher<[ArticleCriteria], Error> {
    return persistentStore.insert(criterias)
  }

  func deleteAll() -> AnyPublisher<[ArticleCriteria], Error> {
    persistentStore
      .update { context in
        let fetched = try context.fetch(ArticleCriteria.fetchRequest)
        fetched.forEach { context.delete($0) }
        return fetched
      }.mapped()
  }

  func fetchArticleCriterias() -> AnyPublisher<[ArticleCriteria], Error> {
    return persistentStore
      .fetch(ArticleCriteria.self) { ArticleCriteria.fetchRequest }
      .mapped()
  }

}
