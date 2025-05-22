//
//  LiveAPIClient.swift
//  FetchChallenge
//
//  Created by Jesse Deda on 5/16/25.
//

import Foundation

final class LiveAPIClient: APIClient {
    let apiConfiguration: APIConfiguration
    
    init(apiConfiguration: APIConfiguration = .production) {
        self.apiConfiguration = apiConfiguration
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        let urlString = apiConfiguration.fetchRecipesURL.rawValue
        guard let url = URL(string: urlString)
        else { throw APIError.failure("Invalid url: \(urlString)") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let responseHTTP = response as? HTTPURLResponse
        else { throw APIError.failedURLResponseConversion }
        
        guard responseHTTP.statusCode == 200
        else { throw APIError.invalidStatusCode(responseHTTP.statusCode) }
        
        let decoded = try? JSONDecoder().decode(FetchRecipesResponse.self, from: data)
        return decoded?.recipes ?? []
    }
}
