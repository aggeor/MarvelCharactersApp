//
//  NetworkImage.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 16/5/24.
//

import SwiftUI

struct NetworkImage: View {
    let url: String
    let gradient: LinearGradient?
    let frameWidth = UIScreen.main.bounds.width/2.38
    let frameHeight = UIScreen.main.bounds.height/3.87
    
    var body: some View {
        CacheAsyncImage(
            url: URL(string: url)!
        ){ phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                
                    .overlay(gradient)
                
                
            case .failure(_):
                Color.clear
                    .frame(width: frameWidth, height: frameHeight)
                
            case .empty:
                ProgressView()
                    .frame(width: frameWidth, height: frameHeight)
                
            @unknown default:
                Color.clear
                    .frame(width: frameWidth, height: frameHeight)
            }
        }
    }
}
