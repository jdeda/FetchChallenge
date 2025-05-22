//
//  APIClient+DTOs.swift
//  FetchChallenge
//
//  Created by Jesse Deda on 5/16/25.
//  Contains all APIClient DTOS (Data Transfer Objects)

import Foundation

struct FetchRecipesResponse: Codable {
    var recipes: [Recipe]
}

struct Recipe: Sendable, Equatable, Codable, Identifiable {
    let id: UUID
    var name: String
    var cuisine: String
    var smallPhotoURL: URL? = nil
    var largePhoto: URL? = nil
    var sourceURL: URL? = nil
    var youtubeURL: URL? = nil
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name = "name"
        case cuisine = "cuisine"
        case smallPhotoURL = "photo_url_small"
        case largePhoto = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

extension Recipe {
    static let mock = Recipe(
        id: UUID(),
        name: "Burgers",
        cuisine: "American"
    )
}

extension Array<Recipe> {
    static let mock: Self = [
        .mock,
        Recipe(
            id: UUID(),
            name: "Burgers",
            cuisine: "American"
        ),
        Recipe(
            id: UUID(),
            name: "Burritos",
            cuisine: "Mexican"
        ),
        Recipe(
            id: UUID(),
            name: "Curry",
            cuisine: "Indian"
        ),
        Recipe(
            id: UUID(),
            name: "Orange Chicken",
            cuisine: "Chinese"
        ),
        Recipe(
            id: UUID(),
            name: "Poutine",
            cuisine: "Canadian"
        ),
        Recipe(
            id: UUID(),
            name: "Pizza",
            cuisine: "Italian"
        ),
        Recipe(
            id: UUID(),
            name: "Cassoulet",
            cuisine: "French"
        ),
        Recipe(
            id: UUID(),
            name: "Byrek",
            cuisine: "Albanian"
        )
    ]
}
