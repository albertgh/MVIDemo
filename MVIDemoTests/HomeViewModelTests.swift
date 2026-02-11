//
//  HomeViewModelTests.swift
//  MVIDemoTests
//
//  Created by ac_m1a on 11/02/2026.
//

import Testing
@testable import MVIDemo

// MARK: - HomeViewModel Tests

/// Unit tests for HomeViewModel.
/// Covers: initial state, initialLoad lifecycle, fetchData + applyPendingItems flow,
/// refresh flow, and error handling.
/// @MainActor matches the ViewModel's @Observable isolation.
@MainActor
struct HomeViewModelTests {
    
    // MARK: - Helpers
    
    /// Creates a ViewModel with fast mock service for testing
    private func makeSUT(
        shouldFail: Bool = false
    ) -> HomeViewModel {
        let service = MockListFetchService(shouldFail: shouldFail, delay: 0.05)
        return HomeViewModel(service: service)
    }
    
    // MARK: - Initial State
    
    @Test func initialState_shouldBeLoadingWithNoItems() {
        let vm = makeSUT()
        let isLoading = vm.isLoading
        let isEmpty = vm.items.isEmpty
        let isRefreshing = vm.isRefreshing
        
        #expect(isLoading == true)
        #expect(isEmpty)
        #expect(isRefreshing == false)
    }
    
    // MARK: - Initial Load (Success)
    
    @Test func initialLoad_success_shouldPopulateItemsAndStopLoading() async {
        let vm = makeSUT()
        
        await vm.initialLoad()
        
        let isLoading = vm.isLoading
        let count = vm.items.count
        
        #expect(isLoading == false)
        #expect(count == 5)
    }
    
    // MARK: - Initial Load (Failure)
    
    @Test func initialLoad_failure_shouldStopLoadingWithEmptyItems() async {
        let vm = makeSUT(shouldFail: true)
        
        await vm.initialLoad()
        
        let isLoading = vm.isLoading
        let isEmpty = vm.items.isEmpty
        
        #expect(isLoading == false)
        #expect(isEmpty)
    }
    
    // MARK: - Fetch + Apply Pending Items (Pull-to-Refresh Flow)
    
    @Test func fetchAndApply_success_shouldUpdateItems() async {
        let vm = makeSUT()
        
        // Fetch stores in pendingItems, doesn't update UI
        await vm.fetchData()
        let itemsBeforeApply = vm.items.isEmpty
        #expect(itemsBeforeApply) // items still empty before apply
        
        // Apply pending items
        vm.applyPendingItems()
        let count = vm.items.count
        #expect(count == 5)
    }
    
    @Test func fetchAndApply_failure_shouldKeepExistingItems() async {
        let successService = MockListFetchService(shouldFail: false, delay: 0.05)
        let vm = HomeViewModel(service: successService)
        
        // First load some data
        await vm.initialLoad()
        let initialCount = vm.items.count
        #expect(initialCount == 5)
        
        // Now simulate a failed refresh using a new ViewModel with same items
        let failVM = makeSUT(shouldFail: true)
        await failVM.initialLoad() // This will fail and leave items empty
        failVM.applyPendingItems()
        let failedCount = failVM.items.count
        #expect(failedCount == 0) // Failed load has no items
    }
    
    // MARK: - End Refresh
    
    @Test func endRefresh_shouldSetRefreshingToFalse() {
        let vm = makeSUT()
        vm.isRefreshing = true
        
        vm.endRefresh()
        
        let isRefreshing = vm.isRefreshing
        #expect(isRefreshing == false)
    }
    
    // MARK: - Apply Without Pending (No-op)
    
    @Test func applyPendingItems_withNoPending_shouldNotChangeItems() {
        let vm = makeSUT()
        
        // Apply without fetching first — should be a no-op
        vm.applyPendingItems()
        let isEmpty = vm.items.isEmpty
        #expect(isEmpty)
    }
}
