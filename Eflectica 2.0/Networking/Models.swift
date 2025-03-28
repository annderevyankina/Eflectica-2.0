//
//  Models.swift
//  APIEflectica
//
//  Created by Анна on 02.12.2024.
//

import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let username: String
    let bio: String
    let contact: String
    let portfolio: String
    let isAdmin: Bool
    let avatar: String
    var favorites: [Effect]

    enum CodingKeys: String, CodingKey {
        case isAdmin = "is_admin"
    }
}

struct Effect: Codable, Identifiable {
    let id: Int
    let name: String
    let img: ImageURLs
    let description: String
    let speed: Int
    let devices: [String]
    let manual: String
    let tagList: [String]
    let programs: [String]
    let comments: [Comment]?

    enum CodingKeys: String, CodingKey {
        case tagList = "tag_list"
    }
}

struct ImageURLs: Codable {
    let url: String
    let q70: QualityImage?
}

struct QualityImage: Codable {
    let url: String
}

struct Collection: Codable {
    let id: Int
    let name: String
    let description: String
    let userId: Int
    let tagList: [String]

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case tagList = "tag_list"
    }
}

struct Comment: Codable {
    let id: Int
    let body: String
    let createdAt: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
    }
}

