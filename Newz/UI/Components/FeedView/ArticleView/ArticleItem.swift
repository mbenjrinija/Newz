//
//  ArticleItem.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 27/9/2022.
//

import SwiftUI

struct ArticleItem: View {
  let payload: Payload
  var namespace: Namespace.ID?
  var showDetails: Bool
  var effectId: String { "ArticleItem\(article.id)" }
  var article: Article { payload.article }
  let headerMaxHeight: CGFloat = 400

  init(payload: Payload, showDetails: Bool = false,
       namespace: Namespace.ID? = nil) {
    self.payload = payload
    self.namespace = namespace
    self.showDetails = showDetails
  }

  var body: some View {
    VStack(spacing: 0) {
      VStack(alignment: .leading) {
        Spacer()
        newsSourceView
          .optionalGeometryEffect(id: "\(effectId):source",
                                  isSource: !payload.expanded, in: namespace)
        titleView
          .optionalGeometryEffect(id: "\(effectId):title",
                                  isSource: !payload.expanded, in: namespace)
      }
      .padding(24)
      .shadow(color: Color.black.opacity(0.6), radius: 3, x: 0, y: 0)
      .background(gradientBackground)
      .background(backgroundImage)
      .frame(maxHeight: headerMaxHeight)

      descriptionView
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .card()
    .optionalGeometryEffect(id: "\(effectId):card",
                            isSource: !payload.expanded, in: namespace)
  }

  var newsSourceView: some View {
    HStack {
      Color.accentColor.frame(width: 3, height: 12).cornerRadius(5)
      Text(article.source ?? "--")
        .font(.caption2)
        .foregroundColor(.white.opacity(0.8))
        .frame(maxWidth: .infinity, alignment: .leading)
    }.animation(.linear(duration: 0.2), value: namespace)
  }

  var titleView: some View {
    Text(article.title ?? "--")
      .font(.title2)
      .fontWeight(.medium)
      .foregroundColor(.white)
      .frame(maxWidth: .infinity, alignment: .topLeading)
      .animation(.linear(duration: 0.2), value: namespace)
  }

  @ViewBuilder
  var descriptionView: some View {
    if showDetails {
      ScrollView {
        Text(payload.article.desc ?? "--")
          .font(.caption)
          .foregroundColor(.white.opacity(0.8))
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(24)
        Spacer()
      }.background(BlurView(effect: .dark))
    }
  }

  var gradientBackground: some View {
    LinearGradient(gradient: Gradient(colors: [.clear, .black]),
                   startPoint: .top, endPoint: .bottom)
  }

  @ViewBuilder
  var backgroundImage: some View {
    RemoteImage(url: article.image, image: payload.image) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(height: headerMaxHeight)
        .fixedSize()
    } placeholder: {
      Image("news-photo")
        .blur(radius: 10)
    }
  }
}

extension ArticleItem {
  struct Payload: Equatable, Identifiable {
    var id = UUID()
    var image: UIImage?
    let article: Article
    var expanded = false
  }
}

struct ArticleItem_Previews: PreviewProvider {
    static var previews: some View {
      VStack {
        ArticleItem(payload: .init(article: .stub.first!))
        Spacer()
      }
    }
}
