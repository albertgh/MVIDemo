//
//  ListCell.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation

import SwiftUI

/// Reusable cell component for displaying a list item
struct ListCell: View {
    
    // MARK: - Properties
    
    let id: Int
    let title: String
    let subtitle: String
    
    // MARK: - Environment
    
    @Environment(\.displayScale) private var displayScale
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // Left: Title
                Text(title)
                    .font(.custom("Helvetica", size: 18))
                    .foregroundStyle(Color(AppCommon.appBlackUIColor))
                    .lineLimit(1)
                    .padding(.leading, 15)
                
                Spacer(minLength: 30)
                
                // Right: Subtitle with max width
                Text(subtitle)
                    .font(.custom("Helvetica", size: 18))
                    .foregroundStyle(Color(AppCommon.appGreyUIColor))
                    .lineLimit(1)
                    .frame(maxWidth: 100, alignment: .trailing)
                
                // Arrow icon
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color(AppCommon.appBlackUIColor))
                    .frame(width: 8, height: 13)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
            }
            .frame(height: 75)
            .contentShape(Rectangle())
            
            // 1px physical pixel divider (0.5pt on 2x, 0.33pt on 3x)
            Divider()
                .frame(height: 1 / displayScale)
                .overlay(Color.secondary.opacity(0.1))
        }
        .accessibilityIdentifier("Home.ListCell.\(id)")
    }
}

#Preview("Single Cell") {
    ListCell(
        id: 1,
        title: "Lorem ipsum",
        subtitle: "Subtitle"
    )
}
