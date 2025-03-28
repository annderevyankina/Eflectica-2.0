// FavoritesView.swift
// APIEflectica
//
// Created by Анна on 24.02.2025.
//
import SwiftUI

struct FavoritesView: View {
    @ObservedObject var userManager: UserManager
    @State private var shouldRestartOnboarding = false

    var body: some View {
        VStack {
            Button("Сбросить онбординг") {
                UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
                shouldRestartOnboarding = true
            }
            .fullScreenCover(isPresented: $shouldRestartOnboarding) {
                OnboardingView()
            }

            Text("Избранное")
                .font(.headline)
                .padding()

            List {
                ForEach(userManager.user.favorites) { effect in
                    Text(effect.name) 
                }
            }
        }
        .navigationBarTitle("Избранное", displayMode: .inline)
    }
}
