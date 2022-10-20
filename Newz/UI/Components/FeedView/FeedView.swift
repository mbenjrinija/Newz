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
  @State var isShowingDetailView = false
  @Namespace var namespace
  var body: some View {
    ZStack {
      LoadableView(loadable: viewModel.articles) { articles in
        ScrollView {
          Spacer(minLength: 40)
          LazyVStack(spacing: 0) {
            ForEach(articles, id: \.url!) { article in
              ArticleItem(payload: .init(article: article), namespace: namespace)
                .aspectRatio(0.9, contentMode: .fit)
                .padding(24)
                .tag(article.url)
                .opacity(viewModel.selectedArticle?.article == article ? 0 : 1)
                .onTapGesture { expand(article) }
            }
          }
        }
      }
    }
    .fullScreenCover(isPresented: $isShowingDetailView) {
      ArticleDetail(selected: $viewModel.selectedArticle, namespace: namespace)
    }
    .onChange(of: viewModel.selectedArticle) { _ in
      withoutAnimation {
        isShowingDetailView = viewModel.selectedArticle != nil
      }
    }
    .onAppear(perform: viewModel.configure)
  }

  func expand(_ article: Article) {
    Task {
      let config = await viewModel.transitionConfig(for: article)
      viewModel.expand(with: config)
    }
  }

}

func withoutAnimation(action: @escaping () -> Void) {
    var transaction = Transaction()
    transaction.disablesAnimations = true
    withTransaction(transaction) {
        action()
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
      FeedView(viewModel: FeedViewModel.stub[1])
    }
}
