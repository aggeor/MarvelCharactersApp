//
//  NetworkImage.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 16/5/24.
//

import SwiftUI

struct NetworkImage: View {
    let url: String
    var body: some View {
        CacheAsyncImage(
            url: URL(string: url)!
        ){ phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                
            case .failure(_):
                Color.clear
                    .frame(width: 180, height: 220)
                
            case .empty:
                Color.clear
                    .frame(width: 180, height: 220)
                
            @unknown default:
                Color.clear
                    .frame(width: 180, height: 220)
            }
        }
    }
}
