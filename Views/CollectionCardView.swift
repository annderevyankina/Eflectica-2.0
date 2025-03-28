//
//  CollectionCardView.swift
//  APIEflectica
//
//  Created by Анна on 24.02.2025.
//

import SwiftUI

struct CollectionCardView: View {
    var collectionCard: CollectionCard

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(collectionCard.name)
                .font(.title2)
                .bold()
            
            Text(collectionCard.description)
                .font(.body)
                .foregroundColor(.gray)
                .lineLimit(3)

            HStack {
                ForEach(collectionCard.tags, id: \.self) { tag in
                    Text("#\(tag)")
                        .font(.footnote)
                        .padding(8)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 160) 
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

struct CollectionCardView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionCardView(collectionCard: CollectionCard(from: Collection(id: 1, name: "Graphic Design", description: "A collection of design resources and tutorials", userId: 1, tagList: ["design", "graphics", "tutorials"])))
            .previewLayout(.sizeThatFits)
    }
}
