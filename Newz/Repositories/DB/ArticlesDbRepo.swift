//
//  ArticlesDbRepo.swift
//  Newz
//
//  Created by Mouad Bj on 16/9/2022.
//

import Foundation
import Combine

protocol ArticlesDbRepository {
  func save(articles: [Article]) -> AnyPublisher<Bool, Error>
}

struct ArticlesDbRepoImpl: ArticlesDbRepository {

  func save(articles: [Article]) -> AnyPublisher<Bool, Error> {
    return Empty().eraseToAnyPublisher()
  }

}
