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
  typealias DBOperation<Result> = (NSManagedObjectContext) throws -> Result
  func fetch<T: Persistable>(_ persistable: T.Type, request:
                             @escaping () -> NSFetchRequest<T.ManagedObject>)
                                -> AnyPublisher<[T.ManagedObject], Error>
  func insert<T: Persistable>(_ object: [T]) -> AnyPublisher<[T], Error>
  func update<Result>(_ operation: @escaping DBOperation<Result>)
                                -> AnyPublisher<Result, Error>
}

protocol Persistable: Equatable where ManagedObject: NSManagedObject {
  associatedtype ManagedObject
  var id: UUID { get }
  init(managedObject: ManagedObject)
  func populate(object: ManagedObject) -> ManagedObject
  static var fetchRequest: NSFetchRequest<ManagedObject> { get }
}

extension Persistable {
  func insert(in context: NSManagedObjectContext) throws -> Self.ManagedObject {
    let inserted = try NSEntityDescription
      .insertNewObject(forEntityName: Self.entityName,
                       into: context) as? Self.ManagedObject ?? {
        throw PersistenceError.failedInsert
      }()
    return populate(object: inserted)
  }

  static var entityName: String {
    String(describing: Self.self)
  }
}

class CoreDataStack {
  static let name = "NewzModel"
  public let container = NSPersistentContainer(name: name)
  public let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)
  private let backgroundQueue = DispatchQueue(label: "coredata")
  private var subscribers = Set<AnyCancellable>()

  public init(storeDescription: NSPersistentStoreDescription? = nil) {
    if let storeDescription = storeDescription {
      container.persistentStoreDescriptions = [storeDescription]
    }
    loadPersistentStores()
  }

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

  func fetch<T: Persistable>(_ persistable: T.Type, request:
                                           @escaping () -> NSFetchRequest<T.ManagedObject>)
  -> AnyPublisher<[T.ManagedObject], Error> {
    let future = Future<[T.ManagedObject], Error> { [weak container] promise in
      guard let context = container?.viewContext else { return }
      context.performAndWait {
        do {
          let fetched = try context.fetch(request())
          promise(.success(fetched))
        } catch {
          promise(.failure(error))
        }
      }
    }
    return onStoreReady
      .flatMap { future }
      .eraseToAnyPublisher()
  }

func update<Result>(_ operation: @escaping DBOperation<Result>)
    -> AnyPublisher<Result, Error> {
  let future = Future<Result, Error> { [weak container, weak backgroundQueue] promise in
    backgroundQueue?.async {
      guard let context = container?.newBackgroundContext() else { return }
      context.configureAsUpdateContext()
      context.performAndWait {
        do {
          let result = try operation(context)
          if context.hasChanges { try context.save() }
          context.reset()
          promise(.success(result))
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

  func insert<T: Persistable>(_ objects: [T]) -> AnyPublisher<[T], Error> {
    self.update { context in
      let result = try objects.map { try $0.insert(in: context) }
      return result.map(T.init(managedObject:))
    }
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

enum PersistenceError: Error {
  case failedInsert
}

extension Publisher {
  func mapped<T: Persistable>()
  -> AnyPublisher<[T], Failure> where Output == [T.ManagedObject] {
      return map { $0.map(T.init(managedObject:)) }
        .eraseToAnyPublisher()
  }
}
