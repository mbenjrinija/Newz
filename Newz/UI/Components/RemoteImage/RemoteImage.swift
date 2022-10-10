//
//  RemoteImage.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 9/10/2022.
//

import SwiftUI
import Combine

struct RemoteImage<Content: View, Placeholder: View>: View {
  @StateObject var viewModel: ViewModel
  var url: String?
  var placeholder: () -> Placeholder
  var content: (Image) -> Content

  init(url: String? = nil,
       image: UIImage? = nil,
       content: @escaping (Image) -> Content = { $0 },
       placeholder: @escaping () -> Placeholder = { EmptyView() }
  ) {
    let viewModel = ViewModel(url: url, image: image)
    self._viewModel = StateObject(wrappedValue: viewModel)
    self.url = url
    self.placeholder = placeholder
    self.content = content
  }

  var body: some View {
    contentView
      .onAppear {
        viewModel.load()
      }
  }

  var contentView: some View {
    Group {
      if case .loaded(let image) = viewModel.image {
        content(Image(uiImage: image))
      } else {
        placeholder()
      }
    }
  }
}

struct RemoteImage_Previews: PreviewProvider {
  static var previews: some View {
    RemoteImage()
  }
}
