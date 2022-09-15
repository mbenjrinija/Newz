//
//  CoreDateStack.swift
//  Newz
//
//  Created by Mouad Bj on 14/9/2022.
//

import Foundation
import CoreData
import Combine

class CoreDataStack {

  public let container = NSPersistentContainer(name: "NewzModel")
  public let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)
  private let backgroundQueue = DispatchQueue(label: "coredata")
  private var subscribers = Set<AnyCancellable>()

  public init() {
    configureContainer()
    loadPersistentStores()
  }

  open func configureContainer() {}
  func loadPersistentStores() {
    backgroundQueue.async { [weak container, isStoreLoaded] in
      container?.loadPersistentStores { _, error in
        DispatchQueue.main.async {
          if let error = error {
            isStoreLoaded.send(completion: .failure(error))
          } else {
            isStoreLoaded.send(true)
          }
        }
      }
    }
  }
}
