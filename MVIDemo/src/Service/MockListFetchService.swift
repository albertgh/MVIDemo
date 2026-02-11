//
//  MockListFetchService.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation

/// Mock implementation of ListServiceProtocol for testing and offline development
final class MockListFetchService: ListServiceProtocol, Sendable {
    
    // MARK: - Configuration
    
    private static let enableArtificialDelay = true
    private static let defaultDelayRange: ClosedRange<TimeInterval> = 3.0...5.0
    
    private let shouldFail: Bool
    private let delayRange: ClosedRange<TimeInterval>?
    
    // MARK: - Initialization
    
    init(
        shouldFail: Bool = false,
        delay: TimeInterval? = nil,
        delayRange: ClosedRange<TimeInterval>? = MockListFetchService.enableArtificialDelay
            ? MockListFetchService.defaultDelayRange
            : nil
    ) {
        self.shouldFail = shouldFail
        if let delay {
            self.delayRange = delay...delay
        } else {
            self.delayRange = delayRange
        }
    }
    
    // MARK: - ListServiceProtocol
    
    func fetchListItems() async throws -> [ListItemEntity] {
        // Simulate network delay
        if let delayRange {
            let delay = Double.random(in: delayRange)
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        // Simulate failure if configured
        if shouldFail {
            throw ListServiceError.networkError(NSError(
                domain: "MockListFetchService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Simulated network failure"]
            ))
        }
        
        // Return mock data
        return [
            ListItemEntity(
                userId: 1,
                id: 1,
                title: "Mock Item One",
                body: "This is the detailed content for the first mock item. It contains some sample text to demonstrate how the content will be displayed in the detail view."
            ),
            ListItemEntity(
                userId: 2,
                id: 2,
                title: "Mock Item Two",
                body: "This is the detailed content for the second mock item. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            ),
            ListItemEntity(
                userId: 3,
                id: 3,
                title: "Mock Item Three",
                body: "This is the detailed content for the third mock item. It has even more text to show how scrolling works in the detail view with longer content that spans multiple lines."
            ),
            ListItemEntity(
                userId: 4,
                id: 4,
                title: "Mock Item Four",
                body: "This is the detailed content for the fourth mock item. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            ),
            ListItemEntity(
                userId: 5,
                id: 5,
                title: "Mock Item Five",
                body: "This is the detailed content for the fifth mock item. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
            )
        ]
    }
}
