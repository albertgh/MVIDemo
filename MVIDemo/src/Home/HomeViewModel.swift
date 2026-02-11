//
//  HomeViewModel.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation
import Observation

/// ViewModel for HomeView following MVVM architecture
/// Uses @Observable macro (iOS 17+) for reactive state management
@Observable
final class HomeViewModel {
    
    // MARK: - Dependencies
    
    private let service: ListServiceProtocol
    
    // MARK: - State
    
    /// List of items fetched from the service
    var items: [ListItemEntity] = []
    
    /// Indicates whether a refresh operation is in progress
    var isRefreshing: Bool = false
    
    /// Pending items to be applied after refresh animation completes
    private var pendingItems: [ListItemEntity]?
    
    // MARK: - Initialization
    
    /// Initialize with a service (defaults to production service)
    /// - Parameter service: Service conforming to ListServiceProtocol
    init(service: ListServiceProtocol = ListFetchService()) {
        self.service = service
    }
    
    // MARK: - Public Methods
    
    /// Fetch data from the service (stores in pendingItems, doesn't update UI yet)
    @MainActor
    func fetchData() async {
        do {
            let fetchedItems = try await service.fetchListItems()
            // Store items but don't update UI yet - wait for animation to complete
            pendingItems = fetchedItems
        } catch {
            pendingItems = nil
        }
    }
    
    /// Called by refresh control when animation completes - apply pending items now
    func endRefresh() {
        isRefreshing = false
    }
    
    /// Called after endRefreshing animation finishes - safe to update UI now
    func applyPendingItems() {
        if let pending = pendingItems {
            items = pending
            pendingItems = nil
        }
    }
}
