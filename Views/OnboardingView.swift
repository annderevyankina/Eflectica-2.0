//
//  OnboardingView.swift
//  APIEflectica
//
//  Created by Анна on 25.02.2025.
//
import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isCompleted = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

    init() {
        _currentPage = State(initialValue: isCompleted ? 5 : 0)
    }

    var body: some View {
        if isCompleted {
            MainTabView()
        } else {
            let pages: [(title: String, description: String, image: String, buttonText: String?, action: () -> Void)] = [
                ("Привет!", "Eflectica помогает находить вдохновение и готовые решения для твоих проектов", "A_Icon", "Давай начнем!", {
                    withAnimation { currentPage += 1 }
                }),
                ("Главная", "Здесь ты можешь найти нужный эффект по категории, задаче и программам", "EffectCards", nil, {}),
                ("Вопросы", "А здесь можно попросить помощь у сообщества, если хочешь докрутить эффект. Также можно дать свой совет и отвечать другим людям", "QuestionCards", nil, {}),
                ("Коллекции", "Чтобы удобно сохранять референсы, полезные ссылки и эффекты с платформы по одной теме, можно использовать коллекции", "CollectionCard", nil, {}),
                ("Избранное", "А чтобы быстро вернуться к эффекту на ноутбуке, сохрани его в избранном на телефоне", "Favorite", "За вдохновением!", {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    isCompleted = true
                })
            ]

            VStack {
                Spacer()

                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(pages[index].image)
                                .resizable()
                                .frame(width: index == 0 ? 150 : 400, height: index == 0 ? 150 : 400)
                                .cornerRadius(index == 0 ? 32 : 10)
                                                        
                            VStack {
                                Text(pages[index].title)
                                    .font(.largeTitle)
                                    .bold()
                                
                                Text(pages[index].description)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding(10)
                            }
                            
                            Spacer()
                            
                            if index == 0 {
                                Button(action: {
                                    pages[index].action()
                                }) {
                                    Text("Давай начнем!")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: 250)
                                        .background(Color("accentColor"))
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                }
                            } else if index == pages.count - 1 {
                                Button(action: {
                                    pages[index].action()
                                }) {
                                    Text("За вдохновением!")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: 250)
                                        .background(Color("accentColor"))
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                }
                            } else {
                                HStack {
                                    Spacer()
                                        HStack {
                                            PageIndicator(currentPage: currentPage, totalPages: pages.count)
                                                .padding(.trailing, 10)
                                            Button(action: {
                                                withAnimation { currentPage += 1 }
                                            }) {
                                                Image("A_Arrow")
                                                    .resizable()
                                                    .frame(width: 50, height: 50)
                                            }
                                        }
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                            }
                        }
                        .background(Color.white.ignoresSafeArea())
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
    }
}

struct PageIndicator: View {
    var currentPage: Int
    var totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(index == currentPage ? Color("accentColor") : Color("ordinaryGrey"))
            }
        }
    }
}

