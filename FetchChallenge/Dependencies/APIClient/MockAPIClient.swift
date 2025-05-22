//
//  MockAPIClient.swift
//  FetchChallenge
//
//  Created by Jesse Deda on 5/16/25.
//

import Foundation

final actor MockAPIClient: APIClient {
    private var fetchRecipesHandler: @Sendable () async throws -> [Recipe]
    
    init(fetchRecipesHandler: @Sendable @escaping () async throws -> [Recipe]) {
        self.fetchRecipesHandler = fetchRecipesHandler
    }
    
    func setFetchRecipes(_ handler: @Sendable @escaping () async throws -> [Recipe]) {
        fetchRecipesHandler = handler
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        try await fetchRecipesHandler()
    }
    
    static func`default`() -> MockAPIClient {
        MockAPIClient {
            try await Task.sleep(for: .seconds(1))
            return .mock
        }
    }
}
