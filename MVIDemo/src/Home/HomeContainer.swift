//
//  HomeContainer.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation

// MARK: - HomeContainer

/// MVI Container for the Home screen.
/// Manages the Home feature's state, processes user intents through a pure reducer,
/// and handles side effects (network requests) in isolation.
final class HomeContainer: MVIContainer<HomeState, HomeIntent, HomeSideEffect> {
    
    // MARK: - Dependencies
    
    private let service: ListServiceProtocol
    
    // MARK: - Initialization
    
    /// Initialize with a service dependency for data fetching.
    /// - Parameter service: Service conforming to ListServiceProtocol (defaults to production)
    init(service: ListServiceProtocol = ListFetchService()) {
        self.service = service
        super.init(initialState: HomeState())
    }
    
    // MARK: - Reducer (Pure Function)
    
    /// Pure state transition function. Given the current state and an intent,
    /// returns the new state and an optional side effect to execute.
    ///
    /// This function contains NO async code, NO side effects — only deterministic state logic.
    override func reduce(state: HomeState, intent: HomeIntent) -> (HomeState, HomeSideEffect?) {
        var newState = state
        
        switch intent {
        case .initialLoad:
            // Set loading phase and trigger data fetch
            newState.phase = .loading
            newState.items = []
            return (newState, .fetchItems)
            
        case .refresh:
            // Keep existing items visible during refresh, trigger data fetch
            newState.phase = .loading
            return (newState, .fetchItems)
            
        case .loadCompleted(let items):
            // Update items and transition to loaded phase
            newState.items = items
            newState.phase = .loaded
            return (newState, nil)
            
        case .loadFailed(let message):
            // Transition to error phase with error message
            newState.phase = .error(message)
            return (newState, nil)
        }
    }
    
    // MARK: - Side Effects (Async Operations)
    
    /// Executes async side effects triggered by the reducer.
    /// Upon completion, dispatches new intents to update the state.
    override func handleSideEffect(_ effect: HomeSideEffect) async {
        switch effect {
        case .fetchItems:
            do {
                let items = try await service.fetchListItems()
                await MainActor.run { send(.loadCompleted(items)) }
            } catch {
                let message = error.localizedDescription
                await MainActor.run { send(.loadFailed(message)) }
            }
        }
    }
}
