//
//  FeedsEditor.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 26/9/2022.
//

import SwiftUI
import Combine

struct FeedListEditor: View {
  @Environment(\.presentationMode) var presentationMode
  @Binding var feedsCriterias: [ArticleCriteria]
  @StateObject var viewModel: ViewModel

  init(feedsCriterias: Binding<[ArticleCriteria]>) {
    self._feedsCriterias = feedsCriterias
    let viewModel = ViewModel(feedsCriterias: feedsCriterias.wrappedValue)
    self._viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    List {
      ForEach($viewModel.feedsCriterias, id: \.id) { $criteria in
        NavigationLink(destination: FeedEditor(feedCriterias: $criteria)) {
          Text(criteria.name ?? "Untitled")
            .font(.title3)
        }
      }
      .onMove { viewModel.move(indexSet: $0, offset: $1) }
      .onDelete { viewModel.delete(indexSet: $0) }
      Spacer()
      Button(action: viewModel.create) {
        Text("Create New")
          .frame(maxWidth: .infinity)
      }
      Button(action: self.save ) {
        Text("Save")
      }.buttonStyle(RoundedButtonStyle())
        .disabled($viewModel.feedsCriterias.isEmpty)
    }.toolbar {
      EditButton()
    }.navigationTitle("Edit Feeds List")
      .alert(error: $viewModel.error)
  }

  func save() {
    viewModel.save(feedsCriterias: $feedsCriterias,
                   presentationMode: presentationMode)
  }
}

struct FeedsEditor_Previews: PreviewProvider {
  static var previews: some View {
    FeedListEditor(feedsCriterias: .constant(ArticleCriteria.stub))
  }
}
