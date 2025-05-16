//
//  LiveAPIClientTests.swift
//  FetchChallengeTests
//
//  Created by Jesse Deda on 5/16/25.
//

@testable import FetchChallenge
import Foundation
import XCTest

final class LiveAPIClientTests: XCTestCase {
    func testFetchRecipesProduction() async throws {
        let api = LiveAPIClient(apiConfiguration: .init(fetchRecipesURL: .production))
        let recipes = try await api.fetchRecipes()
        XCTAssertEqual(recipes.count, 63)
    }
    
    func testFetchRecipesMalformed() async throws {
        let api = LiveAPIClient(apiConfiguration: .init(fetchRecipesURL: .malformed))
        let recipes = try await api.fetchRecipes()
        XCTAssertEqual(recipes.count, 0, "Should get zero, malformed data should be discarded")
    }
    
    func testFetchRecipesEmpty() async throws {
        let api = LiveAPIClient(apiConfiguration: .init(fetchRecipesURL: .empty))
        let recipes = try await api.fetchRecipes()
        XCTAssertEqual(recipes.count, 0, "Should get zero, endpoint should have no data")
    }
}
