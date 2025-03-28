// EffectsView.swift
// APIEflectica
//
// Created by Анна on 24.02.2025.
//
import SwiftUI

struct EffectsView: View {
    var effectCards: [EffectCard]
    @ObservedObject var userManager: UserManager

    @State private var selectedEffect: EffectCard?
    @State private var selectedTags: Set<String> = []
    @State private var isCategoriesExpanded = false

    private var allTags: [String] {
        var tagsSet = Set<String>()
        for effect in effectCards {
            for tag in effect.tags {
                tagsSet.insert(tag)
            }
        }
        return Array(tagsSet).sorted()
    }

    var filteredEffects: [EffectCard] {
        guard !selectedTags.isEmpty else { return effectCards }
        return effectCards.filter { effect in
            !selectedTags.isDisjoint(with: effect.tags)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Все эффекты")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

                Button(action: {
                    withAnimation {
                        isCategoriesExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text("Категории")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(isCategoriesExpanded ? 180 : 0))
                            .animation(.easeInOut(duration: 0.2), value: isCategoriesExpanded)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                }

                if isCategoriesExpanded {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(allTags, id: \.self) { tag in
                            HStack {
                                Button(action: {
                                    if selectedTags.contains(tag) {
                                        selectedTags.remove(tag)
                                    } else {
                                        selectedTags.insert(tag)
                                    }
                                }) {
                                    Image(systemName: selectedTags.contains(tag) ? "checkmark.square.fill" : "square")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(PlainButtonStyle()) 

                                Text(tag)
                                    .font(.body)

                                Spacer()
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding(.horizontal, 16)
                }

                List {
                    ForEach(filteredEffects) { effect in
                        EffectCardView(effectCard: effect)
                            .onTapGesture {
                                selectedEffect = effect
                            }
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 2)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("", displayMode: .inline)
            .sheet(item: $selectedEffect) { effect in
                EffectCardDetailView(effectCard: effect)
                    .navigationBarTitle(effect.title, displayMode: .inline)
            }
        }
    }
}
