//
//  HomeView.swift
//  Newz
//
//  Created by Mouad Bj on 24/9/2022.
//

import SwiftUI

struct HomeView: View {

  @StateObject private var viewModel = ViewModel()
  @State var showHomeToolBar = true

  var body: some View {
    NavigationView {
      ZStack(alignment: .top) {
        if viewModel.titles.isEmpty {
          emptyView
        } else {
          FeedPager(feedsCriterias: $viewModel.feedsCriterias,
                    selected: $viewModel.selectedFeed)
          FeedTabs(titles: viewModel.titles,
                   selected: $viewModel.selectedFeed)
            .opacity(showHomeToolBar ? 1 : 0)
            .transition(.opacity)
            .animation(.linear(duration: 0.2))
        }
      }
      .environment(\.showHomeToolBar, $showHomeToolBar)
      .navigationTitle("My Feeds")
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarHidden(!showHomeToolBar)
      .toolbar {
        ToolbarItem {
          NavigationLink(destination: FeedListEditor(
            feedsCriterias: $viewModel.feedsCriterias)) {
            Image(systemName: "square.and.pencil")
          }
        }
      }
      .onAppear(perform: viewModel.configure)
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

  struct HideBarEnvironmentKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(true)
  }
}

extension EnvironmentValues {
  var showHomeToolBar: Binding<Bool> {
    get { self[HomeView.HideBarEnvironmentKey.self] }
    set { self[HomeView.HideBarEnvironmentKey.self] = newValue }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
