//
//  CacheAsyncImage.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 16/5/24.
//


// This source file is part of https://github.com/pitt500/Pokedex/
//
// Copyright (c) 2023 Pedro Rojas and project authors
// Licensed under MIT License


import SwiftUI


/// `CacheAsyncImage` retrieves an image from a url if it's not yet loaded, or retrieves an image from the list of images in the cache
///
///  Code snippet used: [CacheAsyncImage.swift](https://github.com/pitt500/Pokedex/blob/main/Pokedex/Cache/CacheAsyncImage.swift)
struct CacheAsyncImage<Content>: View where Content:View {
    private let url: URL
    private let content:(AsyncImagePhase) -> Content
    
    init(
        url: URL,
        @ViewBuilder content:@escaping (AsyncImagePhase) -> Content
    ){
        self.url = url
        self.content = content
    }
    var body: some View {
        if let cached = ImageCache[url]{
            content(.success(cached))
        } else {
            AsyncImage(url: url){ phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    
    func cacheAndRender(phase: AsyncImagePhase) -> some View{
        if case .success(let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}

fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]
    
    static subscript(url: URL) -> Image? {
        get{
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
