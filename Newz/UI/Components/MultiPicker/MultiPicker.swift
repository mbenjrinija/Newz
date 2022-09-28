//
//  MultiPicker.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 26/9/2022.
//

import SwiftUI

struct MultiPicker<Item: Hashable, Value: Equatable, Content: View>: View {
  var name: String
  var items: [Item]

  @Binding var selected: [Value]
  @ViewBuilder let viewItem: (Item) -> Content
  let transform: (Item) -> Value
  @State var showOptions = false
  @State var searchText = ""
  var body: some View {
    HStack {
      Text(name)
      Spacer()
      Button(action: { showOptions.toggle() },
             label: {
        Text(selected.isEmpty ? "Select" : "\(selected.count) Selected")
          .fontWeight(selected.isEmpty ? .regular : .bold)
      }
      )
    }
    .sheet(isPresented: $showOptions) {
      VStack {
        optionListView
      }
    }
  }

  var optionListView: some View {
    List(items, id: \.self) { item in
      Button(action: { onSelect(item: item) }, label: {
        HStack {
          Image(systemName: "checkmark")
            .foregroundColor(selected.contains(transform(item))
                             ? .primary : .clear)
          viewItem(item)
          Spacer()
        }.padding()
          .contentShape(Rectangle())
      }).buttonStyle(PlainButtonStyle())
    }
  }

  func onSelect(item: Item) {
    let value = transform(item)
    DispatchQueue.main.async {
      if selected.contains(value) {
        selected.removeAll(where: { $0 == value })
      } else {
        selected.append(value)
      }
    }
  }
}

struct MultiPicker_Previews: PreviewProvider {
  static var previews: some View {
    Parent()
  }

  struct Parent: View {
    var options = ["Kitkat", "Mars", "Toblerone"]
    @State var selected: [String] = []
    var body: some View {
      MultiPicker(name: "My Picker", items: options,
                  selected: $selected) { item in
        Text(item)
      } transform: { $0 }
    }
  }

}
