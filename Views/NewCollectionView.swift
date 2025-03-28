//
//  NewCollectionView.swift
//  APIEflectica
//
//  Created by Анна on 25.02.2025.
//

import SwiftUI

struct NewCollectionView: View {
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var tags: String = ""

    private let apiService = ApiService()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Название", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Описание", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Теги (через запятую)", text: $tags)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    createCollection()
                }) {
                    Text("Добавить")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationTitle("Новая коллекция")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        isPresented = false
                    }
                }
            }
        }
    }

    private func createCollection() {
        let tagList = tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let newCollection = Collection(id: 0, name: name, description: description, userId: 1, tagList: tagList)

        apiService.createCollection(collection: newCollection) { result in
            switch result {
            case .success:
                print("Коллекция успешно создана")
                isPresented = false
            case .failure(let error):
                print("Ошибка при создании коллекции: \(error)")
            }
        }
    }
}

