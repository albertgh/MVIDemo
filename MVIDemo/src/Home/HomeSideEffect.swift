//
//  HomeSideEffect.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation

// MARK: - HomeSideEffect

/// Side effects that can be triggered by the Home reducer.
/// Side effects represent async operations that are isolated from the pure reducer logic.
enum HomeSideEffect: Sendable {
    
    /// Fetch list items from the remote service
    case fetchItems
}
