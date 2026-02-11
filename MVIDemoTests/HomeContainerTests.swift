//
//  HomeContainerTests.swift
//  MVIDemoTests
//
//  Created by ac_m1a on 11/02/2026.
//

import Testing
@testable import MVIDemo

// MARK: - HomeContainer Tests

/// Unit tests for HomeContainer MVI logic.
/// Tests are organized by: reducer (pure state transitions) and integration (full intent → state cycle).
/// @MainActor is required because MVIContainer uses @Observable which is MainActor-isolated.
@MainActor
struct HomeContainerTests {
    
    // MARK: - Initial State
    
    @Test func initialState_shouldBeLoading() {
        let container = HomeContainer(service: MockListFetchService())
        let phase = container.state.phase
        let isEmpty = container.state.items.isEmpty
        
        #expect(phase == .loading)
        #expect(isEmpty)
    }
    
    // MARK: - Reducer: initialLoad
    
    @Test func reduce_initialLoad_shouldSetLoadingPhaseAndReturnFetchEffect() {
        let container = HomeContainer(service: MockListFetchService())
        let startState = HomeState(phase: .loaded, items: [
            ListItemEntity(userId: 1, id: 1, title: "Old", body: "Data")
        ])
        
        let (newState, sideEffect) = container.reduce(state: startState, intent: .initialLoad)
        let phase = newState.phase
        let isEmpty = newState.items.isEmpty
        
        #expect(phase == .loading)
        #expect(isEmpty)
        #expect(sideEffect == .fetchItems)
    }
    
    // MARK: - Reducer: refresh
    
    @Test func reduce_refresh_shouldSetLoadingAndKeepItems() {
        let container = HomeContainer(service: MockListFetchService())
        let existingItems = [
            ListItemEntity(userId: 1, id: 1, title: "Existing", body: "Item")
        ]
        let startState = HomeState(phase: .loaded, items: existingItems)
        
        let (newState, sideEffect) = container.reduce(state: startState, intent: .refresh)
        let phase = newState.phase
        let items = newState.items
        
        #expect(phase == .loading)
        #expect(items == existingItems)
        #expect(sideEffect == .fetchItems)
    }
    
    // MARK: - Reducer: loadCompleted
    
    @Test func reduce_loadCompleted_shouldSetItemsAndLoadedPhase() {
        let container = HomeContainer(service: MockListFetchService())
        let fetchedItems = [
            ListItemEntity(userId: 1, id: 1, title: "New", body: "Item"),
            ListItemEntity(userId: 2, id: 2, title: "Another", body: "Item")
        ]
        let startState = HomeState(phase: .loading, items: [])
        
        let (newState, sideEffect) = container.reduce(state: startState, intent: .loadCompleted(fetchedItems))
        let phase = newState.phase
        let items = newState.items
        
        #expect(phase == .loaded)
        #expect(items == fetchedItems)
        #expect(sideEffect == nil)
    }
    
    // MARK: - Reducer: loadFailed
    
    @Test func reduce_loadFailed_shouldSetErrorPhase() {
        let container = HomeContainer(service: MockListFetchService())
        let startState = HomeState(phase: .loading, items: [])
        let errorMessage = "Network error occurred"
        
        let (newState, sideEffect) = container.reduce(state: startState, intent: .loadFailed(errorMessage))
        let phase = newState.phase
        
        #expect(phase == .error(errorMessage))
        #expect(sideEffect == nil)
    }
    
    // MARK: - Integration: Full Load Cycle
    
    @Test func integration_initialLoad_shouldFetchAndUpdateState() async throws {
        let container = HomeContainer(service: MockListFetchService(delay: 0.1))
        
        container.send(.initialLoad)
        
        // Wait for async side effect to complete
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let phase = container.state.phase
        let count = container.state.items.count
        
        #expect(phase == .loaded)
        #expect(count == 5)
    }
    
    // MARK: - Integration: Error Handling
    
    @Test func integration_loadWithFailure_shouldSetErrorState() async throws {
        let container = HomeContainer(service: MockListFetchService(shouldFail: true, delay: 0.1))
        
        container.send(.initialLoad)
        
        // Wait for async side effect to complete
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let phase = container.state.phase
        
        if case .error = phase {
            // Expected error state
        } else {
            Issue.record("Expected error phase but got \(phase)")
        }
    }
}
