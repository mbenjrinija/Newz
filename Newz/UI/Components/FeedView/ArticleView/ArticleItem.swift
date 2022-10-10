//
//  ArticleItem.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 27/9/2022.
//

import SwiftUI

struct ArticleItem: View {
  let payload: Payload
  let cornerRadius: CGFloat = 25
  var namespace: Namespace.ID?
  var effectPrefix: String { "ArticleItem\(article.id)" }
  var article: Article { payload.article }

  init(payload: Payload, namespace: Namespace.ID? = nil) {
    self.payload = payload
    self.namespace = namespace
  }

  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
      sourceView
        .optionalGeometryEffect(id: "\(effectPrefix):source", in: namespace)
      titleView
        .optionalGeometryEffect(id: "\(effectPrefix):title", in: namespace)
      subtitleView
    }
    .frame(maxWidth: .infinity)
    .shadow(color: Color.black.opacity(0.6),
            radius: 3, x: 0, y: 0)

    .padding()
    .background(gradientBackground)
    .background(
      backgroundImage
    )
    .cornerRadius(cornerRadius)
    .background(shadow)
    .padding(.bottom)
    .optionalGeometryEffect(id: "\(effectPrefix):container", in: namespace)
  }

  var sourceView: some View {
    HStack {
      Color.accentColor.frame(width: 3, height: 12).cornerRadius(5)
      Text(article.source ?? "--")
        .font(.caption2)
        .foregroundColor(.white.opacity(0.8))
        .multilineTextAlignment(.leading)
    }
  }

  var titleView: some View {
    Text(article.title ?? "--")
      .font(.title2)
      .fontWeight(.medium)
      .foregroundColor(.white)
      .multilineTextAlignment(.leading)
  }

  @ViewBuilder
  var subtitleView: some View {
    if payload.expanded {
      Text(article.desc ?? "--")
        .font(.caption)
        .foregroundColor(.white.opacity(0.8))
        .multilineTextAlignment(.leading)
    } else {
      EmptyView()
    }
  }

  var shadow: some View {
    Rectangle()
      .fill(Color.white)
      .cornerRadius(cornerRadius)
      .shadow(color: Color.black.opacity(0.1),
              radius: 5, x: 0, y: 2)
      .shadow(color: Color.black.opacity(0.2),
              radius: 20, x: 0, y: 10)
      .optionalGeometryEffect(id: "\(effectPrefix):shadow", in: namespace)
  }

  var gradientBackground: some View {
    LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5)]),
                   startPoint: .top, endPoint: .bottom)
  }

  @ViewBuilder
  var backgroundImage: some View {
//    if #available(iOS 15.0, *) {
//      AsyncImage(url: URL(string: article.image ?? "")) { image in
//        image
//          .resizable()
//          .aspectRatio(contentMode: .fill)
//          .frame(alignment: .center)
//          .optionalGeometryEffect(id: "\(effectPrefix):background", in: namespace)
//      } placeholder: {
//        ZStack {
//          Image("news-photo")
//          Color.clear.background(.ultraThinMaterial)
//        }
//      }
//    } else {
    RemoteImage(url: article.image, image: payload.image) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(alignment: .center)
          .optionalGeometryEffect(id: "\(effectPrefix):background", in: namespace)
      } placeholder: {
        Image("news-photo")
          .blur(radius: 10)
      }
//    }
  }
}

extension ArticleItem {
  struct Payload {
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
