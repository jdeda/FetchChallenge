//
//  MockImageLoader.swift
//  FetchChallenge
//
//  Created by Jesse Deda on 5/16/25.
//

import Foundation
import SwiftUI

final actor MockImageLoader: ImageLoader {
    private var loadImageHandler: @Sendable (URL) async throws -> UIImage
    
    func setLoadImage(_ loadImage: @escaping @Sendable (URL) async throws -> UIImage) {
        self.loadImageHandler = loadImage
    }
    
    init(loadImage: @Sendable @escaping (URL) async throws -> UIImage) {
        self.loadImageHandler = loadImage
    }
    
    func loadImage(url: URL) async throws -> UIImage {
        try await loadImageHandler(url)
    }
    
    static func `default`() -> MockImageLoader {
        MockImageLoader { _ in
            try await Task.sleep(for: .seconds(1))
            return UIImage(systemName: "carrot.fill") ?? UIImage()
        }
    }
}
