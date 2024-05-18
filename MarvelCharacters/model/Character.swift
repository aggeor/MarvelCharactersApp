//
//  Character.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import Foundation

// Character data model based on the model from the Marvel API
// [Marvel API](https://developer.marvel.com/docs#!/public/)

struct CharacterDataWrapper: Codable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let etag: String?
    let data: CharacterDataContainer?
}

struct CharacterDataContainer: Hashable, Codable{
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [Character]?
}

struct Character: Hashable, Codable{
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: CharacterThumbnail?
}

struct CharacterThumbnail: Hashable, Codable{
    let path: String?
    let `extension`: String?
    // Custom variable to get the full path of a thumbnail
    var fullPath:String?{
        "\(path ?? "").\(`extension` ?? "")"
    }
}
