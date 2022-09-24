//
//  ContentView.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 13/9/2022.
//

import SwiftUI
import Combine

struct ContentView: View {

  @Inject(.Service.articles) var articlesService: ArticlesService

  var body: some View {
    HomeView()
  }

}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
