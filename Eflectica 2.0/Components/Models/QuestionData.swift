//
//  QuestionData.swift
//  APIEflectica
//
//  Created by Анна on 24.02.2025.
//
import Foundation

struct QuestionCard: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var description: String
    var tags: [String]

    init(from question: Question) {
        self.title = question.title
        self.description = question.description
        self.tags = question.tagList
    }
}
