//
//  BlurView.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 17/10/2022.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
  var effect: UIBlurEffect.Style

  func makeUIView(context: Context) -> UIVisualEffectView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: self.effect))
    return view
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {}
}

// A workaround to replace the default background of a fullScreenCover
struct BackgroundBlurView: UIViewRepresentable {
  var effect: UIBlurEffect.Style
  var opacity: CGFloat = 1

  func makeUIView(context: Context) -> UIView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: self.effect))
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = .clear
    }
    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {
    uiView.alpha = opacity
  }
}
