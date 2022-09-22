//
//  CoreDataStackMock.swift
//  NewzTests
//
//  Created by Mouad Bj on 21/9/2022.
//

import Foundation
import Combine
import CoreData
@testable import Newz

class CoreDataStackMock: PersistentStore, Mock {
  struct ContextSnapshot: Equatable {
    let inserted: Int, updated: Int, deleted: Int
  }
  enum Action: Equatable {
    case fetch(String, ContextSnapshot)
    case save(String, ContextSnapshot)
  }

  var recorder = MockActionRecorder<Action>(expected: [])

  func fetch<T: Persistable>(_ persistable: T.Type, request:
                             @escaping () -> NSFetchRequest<T.ManagedObject>) -> AnyPublisher<[T], Error> {
    do {
      let fetchRequest = request()
      let context = container.viewContext
      let managedObjects = try context.fetch(fetchRequest)
      let results = managedObjects.map(T.init(managedObject:))
      record(action: .fetch("\(T.self)", .init(inserted: 0, updated: 0, deleted: 0)))
      return Just(results).setFailureType(to: Error.self).eraseToAnyPublisher()
    } catch {
      return Fail<[T], Error>(error: error).eraseToAnyPublisher()
    }
  }

  func save<T: Persistable>(_ objects: [T]) -> AnyPublisher<[T], Error> {
    do {
      let context = container.viewContext
      context.reset()
      objects.forEach { _ = $0.managedObject(context: context) }
      record(action: .save("\(T.self)", context.snapshot))
      try context.save()
      context.reset()
      return Just(objects).setFailureType(to: Error.self).eraseToAnyPublisher()
    } catch {
      return Fail<[T], Error>(error: error).eraseToAnyPublisher()
    }
  }

  func preload<T: Persistable>(_ objects: [T]) throws {
    objects.forEach { _ = $0.managedObject(context: container.viewContext) }
    if container.viewContext.hasChanges {
      try container.viewContext.save()
    }
    container.viewContext.reset()
  }

  lazy var container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: CoreDataStack.name)
    let storeDescription = NSPersistentStoreDescription()
    storeDescription.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [storeDescription]
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    container.loadPersistentStores { _, error in
      if let error = error { fatalError("\(error)") }
      dispatchGroup.leave()
    }
    dispatchGroup.wait()
    return container
  }()
}

extension NSManagedObjectContext {
  var snapshot: CoreDataStackMock.ContextSnapshot {
    .init(inserted: insertedObjects.count,
          updated: updatedObjects.count,
          deleted: deletedObjects.count)
  }
}
