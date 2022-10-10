//
//  ImageService.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 8/10/2022.
//

import Foundation
import Combine
import UIKit.UIImage

protocol ImageService {
  func loadImage(from url: URL) -> AnyPublisher<UIImage, Error>
}

struct ImageServiceMain: ImageService {
  let loader: ImageLoader
  let cache: any ImageCacheStore
  let backgroundQueue: OperationQueue = {
      let queue = OperationQueue()
      queue.maxConcurrentOperationCount = 5
      return queue
  }()

  func loadImage(from url: URL) -> AnyPublisher<UIImage, Error> {
    if let cachedImage = cache.load(for: url) {
      return Just(cachedImage)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    } else {
      return loader
        .loadImage(from: url)
        .handleEvents(receiveOutput: { image in
          cache.insert(image, for: url)
        })
        .subscribe(on: backgroundQueue)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
  }
}
