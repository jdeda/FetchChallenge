//
//  LiveImageLoaderTests.swift
//  FetchChallengeTests
//
//  Created by Jesse Deda on 5/16/25.
//

@testable import FetchChallenge
import Foundation
import XCTest

final class LiveImageLoaderTests: XCTestCase {
    var loader: LiveImageLoader!
    let storageDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    
    override func setUp() async throws {
        try FileManager.default.createDirectory(at: storageDirectory, withIntermediateDirectories: true)
        loader = LiveImageLoader(storageDirectory: storageDirectory, throwOnCacheFailure: true)
    }
    
    override func tearDown() async throws {
        try FileManager.default.removeItem(at: storageDirectory)
    }
    
    func testLoadImage() async throws {
        /// Ideally this url should be a test endpoint, not one handpicked from the real api
        var url = try URL("https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg")
        let image = try await loader.loadImage(url: url)
        let storedImage = await loader.read(at: url)
        XCTAssertEqual(image.pngData(), storedImage?.pngData())
        
        /// We can't compare Image, because they are not really comparable:
        /// XCTAssertEqual(image, storedImage)
        /// But if we could if got a UIImage, so we could refactor the ImageLoader protocol.
        /// But if we do that the dependency is not as abstract, depends on team and how important testing is
        
        /// Try to fetch from a url that doesn't give image data:
        url = try URL(APIConfiguration.FetchRecipesURL.production.rawValue)
        do {
            _ = try await loader.loadImage(url: url)
            XCTFail("Loading shoud fail this data is not an image")
        } catch {
            
        }
        /// Try to fetch from some url that doesn't connect to network.
        url = URL.temporaryDirectory
        do {
            _ = try await loader.loadImage(url: url)
            XCTFail("Loading should only work by fetching from network")
        } catch {
            
        }
    }
}

fileprivate extension URL {
    init (_ string: String) throws {
        self = try XCTUnwrap(URL(string: string))
    }
}
