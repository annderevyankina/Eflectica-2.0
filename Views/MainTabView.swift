//
//  MainTabView.swift
//  APIEflectica
//
//  Created by Анна on 03.12.2024.
//

import SwiftUI

struct MainTabView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var selectedTab = 0

    @State private var questionCards: [QuestionCard] = []
    @State private var collectionCards: [CollectionCard] = []
    @State private var effectCards: [EffectCard] = []
    
    private let apiService = ApiService()

    @StateObject private var userManager = UserManager()

    func loadData() {
        apiService.fetchQuestions(page: 1, userId: nil) { result in
            switch result {
            case .success(let questions):
                self.questionCards = questions.map { QuestionCard(from: $0) }
            case .failure(let error):
                print("Ошибка при загрузке вопросов: \(error)")
            }
        }
        
        apiService.fetchCollections(page: 1) { result in
            switch result {
            case .success(let collections):
                self.collectionCards = collections.map { CollectionCard(from: $0) }
            case .failure(let error):
                print("Ошибка при загрузке коллекций: \(error)")
            }
        }
        
        apiService.fetchEffects(page: 1, category: nil) { result in
            switch result {
            case .success(let effects):
                self.effectCards = effects.map { effect in
                    EffectCard(from: effect)
                }
            case .failure(let error):
                print("Ошибка при загрузке эффектов: \(error)")
            }
        }

        userManager.loadUserData(userId: 1)
    }

    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selectedTab) {
                    QuestionsView(questionCards: questionCards)
                        .tabItem {
                            Image(selectedTab == 0 ? "questIconActive" : "questIcon")
                        }
                        .tag(0)

                    EffectsView(effectCards: effectCards, userManager: userManager) // Передаем userManager
                        .tabItem {
                            Image(selectedTab == 1 ? "mainIconActive" : "mainIcon")
                        }
                        .tag(1)

                    CollectionsView()
                        .tabItem {
                            Image(selectedTab == 2 ? "colIconActive" : "colIcon")
                        }
                        .tag(2)

                    FavoritesView(userManager: userManager)
                        .tabItem {
                            Image(selectedTab == 3 ? "favIconActive" : "favIcon")
                        }
                        .tag(3)
                }
                .onAppear {
                    loadData()
                }
                
                VStack {
                    if selectedTab == 1 {
                        HStack {
                            NavigationLink(destination: ProfileView()) {
                                Image("defaultProfile")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color("ordinaryGrey"), lineWidth: 1.5))
                                    .padding(10)
                            }
                            Spacer()
                            Button(action: {}) {
                                Image("notifyIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 36, height: 36)
                                    .padding(10)
                            }
                        }
                        .padding(.horizontal)
                        .background(Color.white.opacity(0.8))
                        .frame(height: 50)
                    }
                    Spacer()
                }
            }
        }
    }
}
