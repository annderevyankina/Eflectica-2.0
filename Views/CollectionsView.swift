//
//  CollectionsView.swift
//  APIEflectica
//
//  Created by Анна on 25.02.2025.
//

import SwiftUI

struct CollectionsView: View {
    @State private var collectionCards: [CollectionCard] = []
    @State private var isShowingNewCollectionView = false

    private let apiService = ApiService()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(collectionCards) { collection in
                        CollectionCardView(collectionCard: collection)
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("Коллекции")
            .navigationBarItems(trailing:
                Button(action: {
                    isShowingNewCollectionView = true
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                }
            )
            .sheet(isPresented: $isShowingNewCollectionView) {
                NewCollectionView(isPresented: $isShowingNewCollectionView)
            }
            .onAppear {
                loadCollections()
            }
        }
    }

    private func loadCollections() {
        apiService.fetchCollections(page: 1) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let collections):
                    self.collectionCards = collections.map { CollectionCard(from: $0) }
                case .failure(let error):
                    print("Ошибка при загрузке коллекций: \(error)")
                }
            }
        }
    }
}
