//
//  EffectData.swift
//  APIEflectica
//
//  Created by Анна on 24.02.2025.
//

import Foundation

struct EffectCard: Identifiable {
    var id = UUID()
    var effectID: Int
    var title: String
    var description: String
    var speed: Int
    var devices: String
    var manual: String
    var tags: [String]
    var programs: String
    var imageURL: String
    var comments: [Comment]?

    // Инициализатор для преобразования из модели Effect
    init(from effect: Effect) {
        self.effectID = effect.id
        self.title = effect.name
        self.description = effect.description
        self.speed = effect.speed
        self.devices = effect.devices
        self.manual = effect.manual
        self.tags = effect.tagList.map { $0.replacingOccurrences(of: "_", with: " ") }
        self.programs = effect.programs
        self.imageURL = effect.img.url
        self.comments = effect.comments
    }
}
