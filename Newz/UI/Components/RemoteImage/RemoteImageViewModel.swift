//
//  RemoteImageViewModel.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 9/10/2022.
//

import Foundation
import Combine
import SwiftUI

extension RemoteImage {
  class ViewModel: ObservableObject {
    @Inject(.Service.images) var imageService
    var url: URL?
    @Published var image: Loadable<UIImage> = .notLoaded
    var subs = CancelBag()

    init(url: String?, image: UIImage?) {
      self.url = url == nil ? nil : URL(string: url!)
      if let image = image {
        self.image = .loaded(image)
      } else {
        self.image = .notLoaded
      }
    }

    func load() {
      if case .loaded = image { return }
      if let url = self.url {
        loadImage(from: url)
      } else {
        self.image = .failed(nil, Error.noInput)
      }
    }

    private func loadImage(from url: URL) {
      imageService
        .loadImage(from: url)
        .assignTo(bindingOf(loadable: \.image))
    }
  }
}

// MARK: - Error
extension RemoteImage {
  enum Error: Swift.Error {
    case noInput
  }
}
