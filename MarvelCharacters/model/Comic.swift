//
//  Comic.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import Foundation

// Comic data model based on the model from the Marvel API
// [Marvel API](https://developer.marvel.com/docs#!/public/)

struct ComicDataWrapper: Codable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let etag: String?
    let data: ComicDataContainer?
}

struct ComicDataContainer: Hashable, Codable{
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [Comic]?
}

struct Comic: Hashable, Codable{
    let id: Int?
    let title: String?
    let urls:[Url]?
    let thumbnail: ComicThumbnail
}

struct ComicThumbnail: Hashable, Codable{
    let path: String?
    let `extension`: String?
    // Custom variable to get the full path of a thumbnail
    var fullPath:String?{
            "\(path ?? "").\(`extension` ?? "")"
    }
    
}
struct `Url`: Hashable, Codable{
    let type: String?
    let url: String?
}
