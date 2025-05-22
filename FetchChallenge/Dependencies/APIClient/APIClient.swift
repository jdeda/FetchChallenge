//
//  APIClient.swift
//  FetchChallenge
//
//  Created by Jesse Deda on 5/16/25.
//

import Foundation

protocol APIClient: Sendable  {
    func fetchRecipes() async throws -> [Recipe]
}
