//
//  EffectCardDetailView.swift
//  APIEflectica
//
//  Created by Анна on 24.02.2025.
//

import SwiftUI

struct EffectCardDetailView: View {
    var effectCard: EffectCard
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToCollection = false
    
    private let apiService = ApiService()

    var body: some View {
        NavigationStack {
            VStack {
                closeButton
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        effectImage
                        effectTitle
                        effectDescription
                        programsSection
                        devicesSection
                        tagsSection
                        instructionSection
                        commentsSection
                        addToCollectionButton
                    }
                }
            }
        }.onAppear {
            apiService.fetchComments(page: <#Int#>, commentableId: <#Int#>, commentableType: <#String#>, completion: <#(Result<[Comment], any Error>) -> Void#>)
        }
        
    }

    private var closeButton: some View {
        HStack {
            Spacer()
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 16)
        }
        .padding(.top, 16)
    }

    private var effectImage: some View {
        AsyncImage(url: URL(string: effectCard.imageURL)) { image in
            image.resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .cornerRadius(10)
                .padding()
        } placeholder: {
            ProgressView()
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var effectTitle: some View {
        Text(effectCard.title)
            .font(.largeTitle)
            .bold()
            .padding(.horizontal)
    }

    private var effectDescription: some View {
        Text(effectCard.description)
            .font(.body)
            .padding(.horizontal)
    }

    private var programsSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Программы:")
                .font(.headline)
            Text(effectCard.programs)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }

    private var devicesSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Поддерживаемые устройства:")
                .font(.headline)
            Text(effectCard.devices)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }

    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Теги:")
                .font(.headline)
            HStack {
                ForEach(effectCard.tags, id: \.self) { tag in
                    Text("#\(tag)")
                        .font(.caption)
                        .padding(5)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(5)
                }
            }
        }
        .padding(.horizontal)
    }

    private var instructionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Инструкция:")
                .font(.headline)
            Text("""
            1. Зарегистрируйтесь на сайте
            2. Нажмите на кнопку купить (ничего оплачивать не нужно будет)
            3. Выберите способ установки aescripts + aeplugins
            4. Выберите вашу систему
            5. Установите приложение для скачивания плагинов
            6. После установки вам будет предложен один плагин к установке
            7. Нажмите на кнопку установить. Теперь все готово! Зайдите в After Effects и наслаждайтесь работой с плагином
            """)
                .font(.callout)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }

    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Комментарии")
                .font(.headline)
                .padding(.horizontal)

            if let comments = effectCard.comments, !comments.isEmpty {
                ForEach(comments) { comment in
                    commentView(comment)
                }
            } else {
                Text("Пока нет комментариев")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical, 10)
    }

    private func commentView(_ comment: Comment) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(comment.user.username)
                .font(.subheadline)
                .bold()
            Text(comment.body)
                .font(.body)
            Text(comment.createdAt)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
    }

    private var addToCollectionButton: some View {
        Button(action: { navigateToCollection = true }) {
            Text("Добавить в коллекцию")
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .navigationDestination(isPresented: $navigateToCollection) {
            CollectionsView()
        }
    }
}
