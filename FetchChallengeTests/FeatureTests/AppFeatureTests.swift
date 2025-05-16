//
//  FetchChallengeTests.swift
//  FetchChallengeTests
//
//  Created by Jesse Deda on 5/16/25.
//

import XCTest
@testable import FetchChallenge

@MainActor
final class AppFeatureTests: XCTestCase {
    func testFetchRecipes() async throws {
        /// Setup feature.
        let api = MockAPIClient.default()
        await api.setFetchRecipes { [] }
        let model = AppModel(
            api: api,
            loader: MockImageLoader(loadImage: { _ in throw TestError.loaderShouldNotBeCalled  })
        )
        XCTAssertTrue(model.recipes.isEmpty)
        
        /// No api data, no changes.
        await model.fetchRecipes()
        XCTAssertTrue(model.recipes.isEmpty)
        
        /// API mock data, model should get changes.
        await api.setFetchRecipes { .mock }
        await model.fetchRecipes()
        XCTAssertEqual(model.recipes, .mock)
        
        /// API fails, model shouldn't change.
        await api.setFetchRecipes { throw APIError.failure("Something went wrong") }
        await model.fetchRecipes()
        XCTAssertEqual(model.recipes, .mock)
        
        /// API returns different data, model should change.
        await api.setFetchRecipes { [] }
        await model.fetchRecipes()
        XCTAssertTrue(model.recipes.isEmpty)
    }
    
    enum TestError: Error {
        case loaderShouldNotBeCalled
    }
}
