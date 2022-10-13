//
//  ImageCacheStore.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 8/10/2022.
//

import Foundation
import UIKit.UIImage

protocol ImageCacheStore: CacheStore
  where KeyType == URL, ObjectType == UIImage {}

class ImageCacheStoreMain: ImageCacheStore {
  typealias KeyType = URL
  typealias ObjectType = UIImage
  typealias Cache = NSCache<AnyObject, AnyObject>
  let memoryLimit = 1024 * 1024 * 100 // 100MB
  let lock = NSLock()
  private lazy var rawImageCache: Cache = {
    let cache = Cache()
    cache.totalCostLimit = self.memoryLimit
    return cache
  }()
  private lazy var decodedImageCache: Cache = {
    let cache = Cache()
    cache.totalCostLimit = self.memoryLimit
    return cache
  }()

  // MARK: - implementation
  func insert(_ object: UIImage?, for key: URL) {
    guard let image = object else { return remove(for: key) }
    cache(image: image, in: rawImageCache, for: key)
    cache(image: image.decodedImage(), in: decodedImageCache, for: key)
  }

  func load(for key: URL) -> UIImage? {
    lock.lock(); defer { lock.unlock() }
    if let image = from(cache: decodedImageCache, for: key) {
      return image
    }
    if let image = from(cache: rawImageCache, for: key) {
      let decoded = image.decodedImage()
      cache(image: decoded, in: decodedImageCache, for: key)
      return decoded
    }
    return nil
  }

  func remove(for key: URL) {
    lock.lock(); defer { lock.unlock() }
    rawImageCache.removeObject(forKey: key as AnyObject)
    decodedImageCache.removeObject(forKey: key as AnyObject)
  }

  func removeAll() {
    rawImageCache.removeAllObjects()
    decodedImageCache.removeAllObjects()
  }

  func cache(image: UIImage, in cache: Cache, for key: URL) {
    cache.setObject(image as AnyObject,
                    forKey: key as AnyObject,
                    cost: image.diskSize)
  }

  func from(cache: Cache, for key: URL) -> UIImage? {
    cache.object(forKey: key as AnyObject) as? UIImage
  }
}

extension UIImage {
  func decodedImage() -> UIImage {
    guard let cgImage = cgImage else { return self }
    let size = CGSize(width: cgImage.width, height: cgImage.height)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: nil,
                            width: Int(size.width),
                            height: Int(size.height),
                            bitsPerComponent: 8,
                            bytesPerRow: cgImage.bytesPerRow,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
    context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
    guard let decodedImage = context?.makeImage() else { return self }
    return UIImage(cgImage: decodedImage)
  }

  // Rough estimation of how much memory image uses in bytes
  var diskSize: Int {
      guard let cgImage = cgImage else { return 0 }
      return cgImage.bytesPerRow * cgImage.height
  }
}
