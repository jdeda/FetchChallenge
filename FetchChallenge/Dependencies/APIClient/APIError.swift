//
//  APIError.swift
//  FetchChallenge
//
//  Created by Jesse Deda on 5/16/25.
//

import Foundation

enum APIError: Error {
    case failure(String)
    case failedURLResponseConversion
    case invalidStatusCode(Int)
    
    var description: String {
        switch self {
        case let .failure(string):
            return string
        case .failedURLResponseConversion:
            return "Failed to convert URL to HTTPURLResponse"
        case let .invalidStatusCode(status):
            return "Invalid status code of: \(status)"
        }
    }
}
