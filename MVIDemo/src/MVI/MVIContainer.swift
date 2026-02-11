//
//  MVIContainer.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation
import Observation

// MARK: - MVIContainer

/// Generic MVI (Model-View-Intent) container that serves as the single source of truth
/// for a feature's state. It enforces unidirectional data flow:
///
///   View → Intent → reduce() → new State + optional SideEffect → handleSideEffect() → Intent → ...
///
/// Subclasses must override `reduce(state:intent:)` and `handleSideEffect(_:)`.
///
/// - State: The immutable state struct representing the UI state
/// - Intent: An enum of all possible user actions / events
/// - SideEffect: An enum of async operations triggered by the reducer
@Observable
class MVIContainer<State: Equatable, Intent, SideEffect> {
    
    // MARK: - Published State
    
    /// The current state of the feature. Views observe this for rendering.
    private(set) var state: State
    
    // MARK: - Initialization
    
    /// Initialize the container with an initial state.
    /// - Parameter initialState: The starting state for this feature
    init(initialState: State) {
        self.state = initialState
    }
    
    // MARK: - Intent Dispatch
    
    /// Send an intent to the container. This is the ONLY way to trigger state changes.
    /// The intent is processed synchronously through the reducer, and any resulting
    /// side effect is executed asynchronously.
    ///
    /// - Parameter intent: The user action or event to process
    @MainActor
    func send(_ intent: Intent) {
        let (newState, sideEffect) = reduce(state: state, intent: intent)
        state = newState
        
        if let sideEffect = sideEffect {
            Task { [weak self] in
                await self?.handleSideEffect(sideEffect)
            }
        }
    }
    
    // MARK: - Subclass Overrides
    
    /// Pure function that computes the next state and optional side effect from the
    /// current state and an intent. This function MUST be free of side effects.
    ///
    /// - Parameters:
    ///   - state: The current state
    ///   - intent: The intent to process
    /// - Returns: A tuple of (new state, optional side effect to execute)
    func reduce(state: State, intent: Intent) -> (State, SideEffect?) {
        fatalError("Subclasses must override reduce(state:intent:)")
    }
    
    /// Executes an async side effect (e.g., network request, database query).
    /// Upon completion, dispatch new intents via `send()` to update the state.
    ///
    /// - Parameter effect: The side effect to execute
    func handleSideEffect(_ effect: SideEffect) async {
        fatalError("Subclasses must override handleSideEffect(_:)")
    }
}
