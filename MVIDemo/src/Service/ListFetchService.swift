//
//  ListFetchService.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation


/// Production implementation of ListServiceProtocol that fetches data from remote API.
/// Marked @unchecked Sendable because URLSession and JSONDecoder are thread-safe but not formally Sendable.
final class ListFetchService: ListServiceProtocol, @unchecked Sendable {
    
    // MARK: - Endpoint Configuration
    
    private enum Endpoint {
        static let root = "https://jsonplaceholder.typicode.com"
        static let path = "posts"
        
        static var fullURL: String {
            "\(root)/\(path)"
        }
    }
    
    // MARK: - Dependencies
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    // MARK: - Initialization
    
    init(
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    // MARK: - ListServiceProtocol
    
    func fetchListItems() async throws -> [ListItemEntity] {
        // Validate and create URL
        guard let url = URL(string: Endpoint.fullURL) else {
            throw ListServiceError.invalidURL
        }
        
        // Perform network request
        let (data, response) = try await urlSession.data(from: url)
        
        // Validate response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ListServiceError.noData
        }
        
        // Decode JSON
        do {
            let items = try jsonDecoder.decode([ListItemEntity].self, from: data)
            return items
        } catch {
            throw ListServiceError.decodingError(error)
        }
    }
}

