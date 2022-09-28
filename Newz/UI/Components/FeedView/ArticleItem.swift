//
//  ArticleItem.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 27/9/2022.
//

import SwiftUI

struct ArticleItem: View {
  var article: Article
  @State var image: UIImage = UIImage()
  let cornerRadius: CGFloat = 25
  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
      HStack {
        Color.accentColor.frame(width: 3, height: 12).cornerRadius(5)
        Text(article.source ?? "--")
          .font(.caption2)
          .foregroundColor(.white.opacity(0.8))
      }
      Text(article.title ?? "--")
        .font(.title2)
        .fontWeight(.medium)
        .foregroundColor(.white)
      Text(article.desc ?? "--")
        .font(.caption)
        .foregroundColor(.white.opacity(0.8))
    }
    .frame(maxWidth: .infinity)
    .shadow(color: Color.black.opacity(0.6),
            radius: 3, x: 0, y: 0)
    .aspectRatio(0.9, contentMode: .fit)
    .padding()
    .background(
      LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5)]),
                     startPoint: .top, endPoint: .bottom)
    )
    .background(
      AsyncImage(url: URL(string: article.image ?? "")) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(alignment: .center)
      } placeholder: {
        ZStack {
          Image("news-photo")
          Color.clear.background(.ultraThinMaterial)
        }
      }
    )
    .cornerRadius(cornerRadius)
    .background(shadow)
    .padding(.bottom)
    .onAppear(perform: loadImage)
  }

  var shadow: some View {
    Rectangle()
      .fill(Color.white)
      .cornerRadius(cornerRadius)
      .shadow(color: Color.black.opacity(0.1),
              radius: 5, x: 0, y: 2)
      .shadow(color: Color.black.opacity(0.2),
              radius: 20, x: 0, y: 10)
  }

  func loadImage() {

  }
}

struct ArticleItem_Previews: PreviewProvider {
    static var previews: some View {
      VStack {
        ArticleItem(article: .stub.last!)
        Spacer()
      }
    }
}
