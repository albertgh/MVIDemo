//
//  EmptyView.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation

import SwiftUI

/// Empty state view matching the launch screen
/// Shows AppLogo centered on red background
struct EmptyView: View {
    var onAppear: (() -> Void)?
    
    var body: some View {
        ZStack {
            
            // App Logo centered
            Image(systemName: "tray.and.arrow.down")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 132, height: 60)
        }
        .onAppear {
            onAppear?()
        }
    }
}

#Preview {
    EmptyView()
}
