//
//  TagView.swift
//  Newz
//
//  Created by MOUAD BENJRINIJA on 27/9/2022.
//

import SwiftUI

struct TagView: View {

  var title: String
  @Binding var tags: [String]
  @State var newTag: String = ""
  @State var alreadyExistError = false

  var body: some View {
    VStack {
      HStack {
        TextField(title, text: $newTag)
          .foregroundColor(alreadyExistError ? .red : .primary)
          .onChange(of: newTag, perform: {_ in onTextChange() })
        Button("Add", action: { self.add() })
          .disabled(alreadyExistError || newTag.isEmpty)
          .buttonStyle(BorderlessButtonStyle())
      }
      FlowLayout(items: tags) { tag in
        Button(action: { delete(tag) }, label: {
          HStack {
            Text(tag)
            Image(systemName: "xmark.circle")
              .foregroundColor(.gray)
          }
          .padding(.leading, 18)
          .padding(.trailing, 10)
          .padding(.vertical, 4)
          .background(
            RoundedRectangle(cornerRadius: 20)
              .foregroundColor(.gray.opacity(0.3))
          ).padding(2)
        }).foregroundColor(.primary)
          .buttonStyle(BorderlessButtonStyle())
      }.padding(.bottom, 8)
    }
  }

  func delete(_ item: String) {
    withAnimation {
      tags.removeAll(where: { $0 == item })
    }
  }

  func onTextChange() {
    withAnimation {
      alreadyExistError = tags.contains(newTag)
    }
  }

  func add() {
    if !alreadyExistError {
      DispatchQueue.main.async {
        tags.append(newTag)
        newTag = ""
      }
    }
  }
}

struct TagView_Previews: PreviewProvider {
  static var previews: some View {
    Parent()
  }
  struct Parent: View {
    @State var keywords = ["Burger", "Tacos", "Pizza", "Tajine"]
    var body: some View {
      VStack {
        TagView(title: "Food", tags: $keywords)
        Spacer()
      }
    }
  }
}
