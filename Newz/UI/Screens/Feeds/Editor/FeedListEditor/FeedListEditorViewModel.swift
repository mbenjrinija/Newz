//
//  FeedListEditorViewModel.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 26/9/2022.
//

import Foundation
import Combine
import SwiftUI

extension FeedListEditor {
  class ViewModel: ObservableObject {
    @Inject(.Service.criterias) var criteriasService

    @Published var feedsCriterias: [ArticleCriteria]
    @Published var error: ErrorAlert?
    var subs = CancelBag()

    init(feedsCriterias: [ArticleCriteria]) {
      self.feedsCriterias = feedsCriterias
    }

    func move(indexSet: IndexSet, offset: Int) {
      feedsCriterias.move(fromOffsets: indexSet, toOffset: offset)
    }

    func delete(indexSet: IndexSet) {
      feedsCriterias.remove(atOffsets: indexSet)
    }

    func save(feedsCriterias: Binding<[ArticleCriteria]>,
              presentationMode: Binding<PresentationMode>) {
      let names = self.feedsCriterias.map(\.name)
      if !names.allSatisfy({!($0?.isEmpty ?? false)}) {
        error = ErrorAlert(message: "Please fill empty names")
      } else if Set(names).count != names.count {
        error = ErrorAlert(message: "Names must be unique")
      } else {
        criteriasService.save(criterias: self.feedsCriterias)
          .receive(on: DispatchQueue.main)
          .sink(receiveCompletion: {[weak self] completion in
            if case .failure(let error) = completion {
              self?.error = ErrorAlert(message: error.localizedDescription)
            }
          }, receiveValue: { values in
            feedsCriterias.wrappedValue = values
            presentationMode.wrappedValue.dismiss()
          }).store(in: &subs)
      }
    }

    func create() {
      DispatchQueue.main.async { [weak self] in
        self?.feedsCriterias.append(ArticleCriteria(name: "Untitled"))
      }
    }
  }

}
