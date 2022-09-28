//
//  ArticleCriteria+CoreData.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 27/9/2022.
//

import Foundation
import CoreData

extension ArticleCriteria: Persistable {

  init(managedObject: ArticleCriteriaManagedObject) {
    self.id = managedObject.id ?? UUID()
    self.name = managedObject.name
    self.minDate = managedObject.minDate
    self.sources = managedObject.sources
    self.categories = managedObject.categories
    self.countries = managedObject.countries
    self.languages = managedObject.languages
    self.keywords = managedObject.keywords
  }

  func populate(object: ArticleCriteriaManagedObject) -> ArticleCriteriaManagedObject {
    object.id = self.id
    object.name = self.name
    object.minDate = self.minDate
    object.sources = self.sources
    object.categories = self.categories
    object.countries = self.countries
    object.languages = self.languages
    object.keywords = self.keywords
    return object
  }
  static var fetchRequest: NSFetchRequest<ArticleCriteriaManagedObject> {
    ArticleCriteriaManagedObject.fetchRequest()
  }
}
