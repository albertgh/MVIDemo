//
//  ListServiceProtocol.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation


/// Protocol defining the contract for list data fetching services
protocol ListServiceProtocol {
    /// Fetches list items from the data source
    /// - Returns: Array of ListItemEntity
    /// - Throws: Error if fetching fails
    func fetchListItems() async throws -> [ListItemEntity]
}

/// Errors that can occur during list fetching
enum ListServiceError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .noData:
            return "No data received from server"
        }
    }
}

