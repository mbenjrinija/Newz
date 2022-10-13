//
//  ImageLoader.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 8/10/2022.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ImageLoader {
  func loadImage(from url: URL) -> AnyPublisher<UIImage, Error>
}

struct ImageLoaderMain: ImageLoader {

  let session: URLSession

  func loadImage(from url: URL) -> AnyPublisher<UIImage, Error> {
    session
      .dataTaskPublisher(for: url)
      .mapData()
      .tryMap {
        try UIImage(data: $0)?.thumbnail() ?? {
          throw ImageLoaderError.invalidData
        }()
      }
      .eraseToAnyPublisher()
  }

}

enum ImageLoaderError: Error {
  case invalidData
}

extension UIImage {
  func thumbnail() -> UIImage? {
    guard let imageData = self.pngData() else { return nil }
    let options = [
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceThumbnailMaxPixelSize: 1000] as CFDictionary
    guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
    guard let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else { return nil }
    return UIImage(cgImage: imageReference)
  }
}
