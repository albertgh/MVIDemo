//
//  HomeIntent.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation

// MARK: - HomeIntent

/// All possible user actions and system events for the Home screen.
/// Intents are the ONLY way to trigger state changes in the MVI pattern.
enum HomeIntent {
    
    /// User opened the screen — trigger initial data load
    case initialLoad
    
    /// User pulled to refresh — reload data
    case refresh
    
    /// Data fetch completed successfully with items
    case loadCompleted([ListItemEntity])
    
    /// Data fetch failed with an error message
    case loadFailed(String)
}
