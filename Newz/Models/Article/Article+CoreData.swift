//
//  Article+CoreData.swift
//  Newz
//
//  Created by Mouad Bj on 14/9/2022.
//

import Foundation
import CoreData

extension Article: Persistable {

  init(managedObject: ArticleManagedObject) {
    self.id = managedObject.id!
    self.author = managedObject.author
    self.title = managedObject.title
    self.desc = managedObject.desc
    self.url = managedObject.url
    self.source = managedObject.source
    self.image = managedObject.image
    self.category = managedObject.category
    self.language = managedObject.language
    self.country = managedObject.country
    self.publishedAt = managedObject.publishedAt
  }

  func populate(object: ArticleManagedObject) -> ArticleManagedObject {
    object.id = self.id
    object.author = self.author
    object.title = self.title
    object.desc = self.desc
    object.url = self.url
    object.source = self.source
    object.image = self.image
    object.category = self.category
    object.language = self.language
    object.country = self.country
    object.publishedAt = self.publishedAt
    return object
  }

  static var fetchRequest: NSFetchRequest<ArticleManagedObject> {
    ArticleManagedObject.fetchRequest()
  }
}
