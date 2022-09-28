//
//  FeedEditor.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 26/9/2022.
//

import SwiftUI

struct FeedEditor: View {
  @Environment(\.presentationMode) var presentationMode
  @Binding var feedCriterias: ArticleCriteria
  @State var viewModel: ViewModel

  init(feedCriterias: Binding<ArticleCriteria>) {
    self._feedCriterias = feedCriterias
    let viewModel = ViewModel(feedCriterias: feedCriterias.wrappedValue)
    self._viewModel = State(initialValue: viewModel)
  }

  var body: some View {
    Form {
      TextField("Name", text: $viewModel.name)
      MultiPicker(name: "Categories",
                  items: Constants.Criterias.categories,
                  selected: $viewModel.categories) { item in
        Text(item.capitalized)
      } transform: { $0 }
      MultiPicker(name: "Countries",
                  items: Constants.Criterias.countries,
                  selected: $viewModel.countries) { item in
        Text(item.value)
      } transform: { $0.key }
      MultiPicker(name: "Languages",
                  items: Constants.Criterias.languages,
                  selected: $viewModel.languages) { item in
        Text(item.value)
      } transform: { $0.key }
      TagView(title: "Keywords", tags: $viewModel.keywords)
      Spacer()
      Button(action: self.apply ) {
        Text("Apply")
      }.buttonStyle(RoundedButtonStyle())
    }.navigationTitle("Feed Settings")
  }

  func apply() {
    viewModel.save(feedCriterias: $feedCriterias,
                   presentationMode: presentationMode)
  }
}

extension FeedEditor {
  struct ViewModel {

    var name: String
    var sources: [String]
    var categories: [String]
    var countries: [String]
    var languages: [String]
    var keywords: [String]
    var minDate: Date?
    var maxDate: Date?
    var sort: ArticleCriteria.Sort?

    init(feedCriterias: ArticleCriteria) {
      name = feedCriterias.name ?? ""
      sources = feedCriterias.sources ?? []
      categories = feedCriterias.categories ?? []
      countries = feedCriterias.countries ?? []
      languages = feedCriterias.languages ?? []
      keywords = feedCriterias.keywords ?? []
      minDate = feedCriterias.minDate
      maxDate = feedCriterias.maxDate
      sort = feedCriterias.sort ?? .publishedAsc
    }

    func save(feedCriterias: Binding<ArticleCriteria>,
              presentationMode: Binding<PresentationMode>) {
      // TODO: Check existence of name
      var newCriterias = ArticleCriteria()
      newCriterias.name = name
      newCriterias.sources = sources
      newCriterias.categories = categories
      newCriterias.countries = countries
      newCriterias.languages = languages
      newCriterias.keywords = keywords
      newCriterias.minDate = minDate
      newCriterias.maxDate = maxDate
      newCriterias.sort = sort
      feedCriterias.wrappedValue = newCriterias
      presentationMode.wrappedValue.dismiss()
    }
  }
}

struct FeedEditor_Previews: PreviewProvider {
    static var previews: some View {
      FeedEditor(feedCriterias: .constant(ArticleCriteria()))
    }
}
