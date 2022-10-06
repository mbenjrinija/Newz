//
//  FeedView.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 25/9/2022.
//

import SwiftUI
import Combine

struct FeedView: View {
  @ObservedObject var viewModel: FeedViewModel

  var body: some View {
    LoadableView(loadable: viewModel.articles) { articles in
      List(articles, id: \.id) { article in
        ArticleItem(article: article)
      }
      .listRowSeparator(.hidden)
      .listStyle(.plain)
    }.onAppear(perform: viewModel.configure)
  }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
      FeedView(viewModel: FeedViewModel.stub[1])
    }
}

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
