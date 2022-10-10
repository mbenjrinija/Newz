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
  @Namespace var namespace
  var body: some View {
    ZStack {
      LoadableView(loadable: viewModel.articles) { articles in
        List(articles, id: \.url!) { article in
          ArticleItem(payload: .init(article: article),
                      namespace: namespace)
            .aspectRatio(0.9, contentMode: .fit)
            .tag(article.url)
            .onTapGesture { expand(article) }
        }
        .listStyle(.plain)
        ArticleExpanded(selected: $viewModel.selectedArticle,
                        namespace: namespace)
      }
    }.onAppear(perform: viewModel.configure)
  }

  func expand(_ article: Article) {
    Task {
      let config = await viewModel.transitionConfig(for: article)
      withAnimation(.spring()) {
        viewModel.expand(with: config)
      }
    }
  }

  func collapse() {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
      withAnimation {
        viewModel.collapseArticle()
      }
    }
  }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
      FeedView(viewModel: FeedViewModel.stub[1])
    }
}
