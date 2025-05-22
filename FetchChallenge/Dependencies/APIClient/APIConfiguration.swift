//
//  APIConfiguration.swift
//  FetchChallenge
//
//  Created by Jesse Deda on 5/16/25.
//

import Foundation

struct APIConfiguration {
    var fetchRecipesURL: FetchRecipesURL = .production
    
    enum FetchRecipesURL: String {
        case production = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        case malformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        case empty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    }

    static let production: APIConfiguration = .init(fetchRecipesURL: .production)
}
