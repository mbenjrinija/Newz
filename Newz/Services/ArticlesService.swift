//
//  ArticlesService.swift
//  Newz
//
//  Created by Mouad Bj on 22/9/2022.
//

import Foundation
import Combine

protocol ArticlesService {
  func loadLiveArticles(filter: Criteria.Article?, sort: Criteria.Sort?,
                    limit: Int, offset: Int) -> AnyPublisher<[Article], Error>
  
  func loadSavedArticles() -> AnyPublisher<[Article], Error>
}

struct ArticlesServiceImpl: ArticlesService {
  let persistentStore: ArticlesDbRepository
  let apiRepository: ArticlesApiRepository
  
  func loadLiveArticles(filter: Criteria.Article?, sort: Criteria.Sort?,
                    limit: Int, offset: Int) -> AnyPublisher<[Article], Error> {
    Empty().eraseToAnyPublisher()
  }
  
  func loadSavedArticles() -> AnyPublisher<[Article], Error> {
    Empty().eraseToAnyPublisher()
  }
}

struct Criteria {
  struct Article {
    var sources: [String]?
    var categories: [String]?
    var countries: [String]?
    var languages: [String]?
    var keywords: [String]?
    var mindDate: Date?
    var maxDate: Date?
  }
  enum Sort: String {
    case publishedDesc = "published_desc"
    case publishedAsc = "published_asc"
    case popularity = "popularity"
  }
}
