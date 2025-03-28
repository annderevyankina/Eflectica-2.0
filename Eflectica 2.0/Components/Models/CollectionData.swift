//
//  CollectionData.swift
//  APIEflectica
//
//  Created by Анна on 24.02.2025.
//

import Foundation

struct CollectionCard: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var tags: [String]
    
    init(from collection: Collection) {
        self.name = collection.name
        self.description = collection.description
        self.tags = collection.tagList
    }
}
