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
    NavigationView {
      VStack {
        if viewModel.feedCriterias.isEmpty {
          emptyView
        } else {
          FeedTabs(titles: viewModel.titles,
                   selected: $viewModel.selectedFeed)
          FeedPager(feedCriterias: viewModel.feedCriterias,
                    selected: $viewModel.selectedFeed)
        }
      }
      .navigationTitle("My Feeds")
      .navigationBarTitleDisplayMode(.large)
    }
  }

  var emptyView: some View {
    VStack {
      Image(systemName: "newspaper")
        .font(.largeTitle)
        .foregroundColor(.gray)
      Text("No feed")
        .foregroundColor(.gray)
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
