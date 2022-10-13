//
//  LoadableView.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 7/10/2022.
//

import SwiftUI

struct LoadableView<T, Content: View>: View {
  var loadable: Loadable<T>
  @ViewBuilder let loadedView: (T) -> Content

  var body: some View {
    switch loadable {
    case .notLoaded:
      Text("Not Loaded!")
        .font(.caption)
        .foregroundColor(.gray)
    case .loading:
      VStack {
        ProgressView()
          .padding()
        Text("  Loading..")
          .font(.caption)
          .foregroundColor(.gray)
      }
    case .failed:
      VStack {
        Image(systemName: "exclamationmark.triangle")
          .font(.largeTitle)
          .foregroundColor(.gray)
        Text("Unable to load!")
          .font(.caption)
          .foregroundColor(.gray)
      }
    case .loaded(let loadedValue):
      loadedView(loadedValue)
    }
  }
}
