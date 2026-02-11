//
//  HomeState.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation

// MARK: - HomeState

/// Represents the complete, immutable UI state for the Home screen.
/// This is the single source of truth — the View renders purely from this struct.
struct HomeState: Equatable {
    
    /// The current phase of the Home screen lifecycle
    enum Phase: Equatable {
        /// Initial loading state — show spinner
        case loading
        /// Data successfully loaded — show list or empty view
        case loaded
        /// An error occurred — show error message
        case error(String)
    }
    
    /// Current lifecycle phase
    var phase: Phase = .loading
    
    /// The list items to display. Empty array when no data or during loading.
    var items: [ListItemEntity] = []
}
