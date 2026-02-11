//
//  NetworkPermissionService.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation
import Network

/// Service to check and trigger network permission prompts
final class NetworkPermissionService {
    
    // MARK: - Singleton
    
    static let shared = NetworkPermissionService()
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Checks if network permission has been requested, if not, triggers a simple request
    /// This will cause iOS to show the network permission alert on first call
    func ensureNetworkPermission() async {
        // Simple HEAD request to a reliable endpoint to trigger permission prompt
        // Using HEAD instead of GET as we don't need the response body
        guard let url = URL(string: "https://www.google.com") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 5.0
        
        // We don't care about the result, just that the request triggers the permission alert
        _ = try? await URLSession.shared.data(for: request)
    }
}
