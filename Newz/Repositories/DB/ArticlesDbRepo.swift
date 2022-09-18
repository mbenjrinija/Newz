//
//  ArticlesDbRepo.swift
//  Newz
//
//  Created by Mouad Bj on 16/9/2022.
//

import Foundation
import Combine

protocol ArticlesDbRepository {
  func save(articles: [Article]) -> AnyPublisher<[Article], Error>
  func fetchArticles() -> AnyPublisher<[Article], Error>
}

struct ArticlesDbRepoImpl: ArticlesDbRepository {

  let persistentStore: PersistentStore

  func save(articles: [Article]) -> AnyPublisher<[Article], Error> {
    return persistentStore.save(articles)
  }

  func fetchArticles() -> AnyPublisher<[Article], Error> {
    return persistentStore.fetch(Article.self) { Article.fetchRequest }
  }

}
