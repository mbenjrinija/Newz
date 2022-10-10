//
//  CacheStore.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 8/10/2022.
//

import Foundation

protocol CacheStore {
  associatedtype KeyType
  associatedtype ObjectType
  func insert(_ object: ObjectType?, for key: KeyType)
  func load(for key: KeyType) -> ObjectType?
  func remove(for key: KeyType)
  func removeAll()
}
