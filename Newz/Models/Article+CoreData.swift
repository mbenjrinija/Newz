//
//  Article+CoreData.swift
//  Newz
//
//  Created by Mouad Bj on 14/9/2022.
//

import Foundation
import CoreData

extension Article {

    init(managedObject: ArticleManagedObject) {
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

    func managedObject(context: NSManagedObjectContext) -> ArticleManagedObject {
        let article = ArticleManagedObject(context: context)
        article.author = self.author
        article.title = self.title
        article.desc = self.desc
        article.url = self.url
        article.source = self.source
        article.image = self.image
        article.category = self.category
        article.language = self.language
        article.country = self.country
        article.publishedAt = self.publishedAt
        return article
    }
}
