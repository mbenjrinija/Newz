//
//  HomeView.swift
//  Newz
//
//  Created by Mouad Bj on 24/9/2022.
//

import SwiftUI

struct HomeView: View {

  @StateObject private var viewModel = ViewModel()

  var body: some View {
    VStack {
      switch viewModel.articles {
      case .loading:
        Text("Loading...")
      case .failed(_, let error):
        Text("Error: \(error.localizedDescription)")
      case .loaded(let articles):
        List(articles.data ?? []) {
          Text($0.title ?? "--")
        }
      case .notLoaded:
        Text("Nothing loaded")
      }
    }.onAppear {
      viewModel.loadArticles()
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
