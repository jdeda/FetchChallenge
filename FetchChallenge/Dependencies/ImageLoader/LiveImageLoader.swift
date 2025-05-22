//
//  LiveImageLoader.swift
//  FetchChallenge
//
//  Created by Jesse Deda on 5/16/25.
//

import Foundation
import SwiftUI

/// ImageLoader dependency that loads images from network and caches them to local disk
final actor LiveImageLoader: ImageLoader {
    let storageDirectory: URL
    private var throwOnCacheFailure: Bool
    
    init(storageDirectory: URL = LiveImageLoader.cacheRootURL, throwOnCacheFailure: Bool = true) {
        self.storageDirectory = storageDirectory
        self.throwOnCacheFailure = throwOnCacheFailure
    }
    
    func loadImage(url: URL) async throws -> UIImage {
        if let image = read(at: url) {
            return image
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let responseHTTP = response as? HTTPURLResponse
        else { throw ImageCacheError.invalidHTTPResponse }
        guard responseHTTP.statusCode == 200
        else { throw ImageCacheError.invalidHTTPStatsCode(responseHTTP.statusCode) }
        
        do {
            try write(data, at: url)
        } catch {
            if throwOnCacheFailure {
                throw ImageCacheError.imageConversionFailure
            }
        }
        
        return try image(from: data)
    }
    
    func image(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data)
        else { throw ImageCacheError.imageConversionFailure }
        return image
    }
    
    func read(at url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: path(at: url))
        else { return nil }
        return try? image(from: data)
    }
    
    func write(_ data: Data, at url: URL) throws {
        _ = try image(from: data)
        try data.write(to: path(at: url), options: [.atomic, .completeFileProtection])
    }
    
    func path(at url: URL) -> URL {
        let path = url.absoluteString.replacingOccurrences(of: "/", with: "-")
        let new = storageDirectory.appendingPathComponent(path)
        return new
    }
    
    enum ImageCacheError: Error {
        case imageConversionFailure
        case cacheReadFailure
        case cacheWriteFailure
        case invalidHTTPResponse
        case invalidHTTPStatsCode(Int)
        
        var description: String {
            switch self {
            case .imageConversionFailure:
                "Failed to convert data to image from data"
            case .cacheReadFailure:
                "Failed to read data from cache"
            case .cacheWriteFailure:
                "Failed to write data from cache"
            case .invalidHTTPResponse:
                "Invalid HTTP response"
            case let .invalidHTTPStatsCode(code):
                "Invalid HTTP status code: \(code)"
            }
        }
    }
    
    static let cacheRootURL: URL = {
        do {
            let fm = FileManager.default
            let root = try fm.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            
            let dir = root.appendingPathComponent("FetchChallengeImageCache", isDirectory: true)
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            return dir
        } catch {
            fatalError("Failed to create cache root URL: \(error)")
        }
    }()
}
