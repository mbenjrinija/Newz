//
//  Articles.swift
//  Newz
//
//  Created by Mouad Bj on 15/9/2022.
//

import Foundation
import Combine

protocol ArticlesApiRepository {
  func save(articles: [Article]) -> AnyPublisher<Bool, Error>
  func fetchArticles() -> AnyPublisher<[Article], Error>
}

struct ArticlesApiRepoImpl: ArticlesApiRepository {

  func save(articles: [Article]) -> AnyPublisher<Bool, Error> {
    Empty().eraseToAnyPublisher()
  }

  func fetchArticles() -> AnyPublisher<[Article], Error> {
    Empty().eraseToAnyPublisher()
  }

}
