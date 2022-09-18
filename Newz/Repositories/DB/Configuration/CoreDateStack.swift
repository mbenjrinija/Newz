//
//  CoreDateStack.swift
//  Newz
//
//  Created by Mouad Bj on 14/9/2022.
//

import Foundation
import CoreData
import Combine

protocol PersistentStore {

  func fetch<T: Persistable>(_ persistable: T.Type, request:
                             @escaping () -> NSFetchRequest<T.ManagedObject>) -> AnyPublisher<[T], Error>
  func save<T: Persistable>(_ object: [T]) -> AnyPublisher<[T], Error>

}

protocol Persistable where ManagedObject: NSManagedObject {
  associatedtype ManagedObject
  init(managedObject: ManagedObject)
  func managedObject(context: NSManagedObjectContext) -> ManagedObject
  static var fetchRequest: NSFetchRequest<ManagedObject> { get }
}

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

  var onStoreReady: AnyPublisher<Void, Error> {
    isStoreLoaded
      .filter { $0 }
      .map { _ in }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

}

extension CoreDataStack: PersistentStore {

  func fetch<T: Persistable>(_ persistable: T.Type, request: @escaping () -> NSFetchRequest<T.ManagedObject> )
                              -> AnyPublisher<[T], Error> {
    let future = Future<[T], Error> { [weak container] promise in
      guard let context = container?.viewContext else { return }
      context.performAndWait {
        do {
          let fetched = try context.fetch(request())
          let results = fetched.map(T.init(managedObject:))
          promise(.success(results))
        } catch {
          promise(.failure(error))
        }
      }
    }
    return onStoreReady
      .flatMap { future }
      .eraseToAnyPublisher()
  }

  func save<T: Persistable>(_ objects: [T]) -> AnyPublisher<[T], Error> {
    let future = Future<[T], Error> { [weak container, weak backgroundQueue] promise in
      backgroundQueue?.async {
        guard let context = container?.newBackgroundContext() else { return }
        context.configureAsUpdateContext()
        context.performAndWait {
          do {
            _ = objects.map { $0.managedObject(context: context) }
            if context.hasChanges { try context.save() }
            context.reset()
            promise(.success(objects))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    return onStoreReady
      .flatMap { future }
      .eraseToAnyPublisher()
  }

}

// MARK: - NSManagedObjectContext

extension NSManagedObjectContext {

  func configureAsReadOnlyContext() {
    automaticallyMergesChangesFromParent = true
    mergePolicy = NSRollbackMergePolicy
    undoManager = nil
    shouldDeleteInaccessibleFaults = true
  }

  func configureAsUpdateContext() {
    mergePolicy = NSOverwriteMergePolicy
    undoManager = nil
  }
}
