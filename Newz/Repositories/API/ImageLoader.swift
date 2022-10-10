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
        try UIImage(data: $0) ?? { throw ImageLoaderError.invalidData}()
      }
      .eraseToAnyPublisher()
  }

}

enum ImageLoaderError: Error {
  case invalidData
}
