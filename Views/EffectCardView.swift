//
//  EffectCardView.swift
//  APIEflectica
//
//  Created by Анна on 24.02.2025.
//

import Foundation
import SwiftUI

struct EffectCardView: View {
    var effectCard: EffectCard
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: effectCard.imageURL)) { image in
                image.resizable()
                     .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(height: 150)
            .cornerRadius(10)
            .clipped() 
            
            Text(effectCard.title)
                .font(.custom("BasisGrotesquePro-Medium", size: 20))
            
            Text(effectCard.description)
                .font(.custom("BasisGrotesquePro-Regular", size: 16))
                .lineLimit(2)
                .padding(.top, 5)
            
            HStack {
                ForEach(effectCard.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.custom("BasisGrotesquePro-Regular", size: 14))
                        .padding(5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }
            }
            .padding(.top, 5)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("borderColor"), lineWidth: 2)
        )
        .padding(.vertical, 8)
    }
}
