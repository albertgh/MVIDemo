//
//  DetailView.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation

import SwiftUI

/// Detail view for displaying the full content of a list item.
/// This screen is display-only with no mutable state or user interactions that change data,
/// so MVI is intentionally not applied here — keeping it simple avoids over-engineering.
struct DetailView: View {
    
    // MARK: - Properties
    
    let item: ListItemEntity
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Metadata
                VStack(alignment: .leading, spacing: 8) {
                    Text("META")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    
                    HStack {
                        Text("ID & UserID:")
                            .foregroundStyle(.secondary)
                        Text("\(item.id) & \(item.userId) ")
                            .fontWeight(.medium)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
                
                // Title Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("TITLE")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    
                    Text(item.title)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                
                // Content Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("CONTENT")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    
                    Text(item.body)
                        .font(.body)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                
            }
            .padding()
        }
        .background(Color(AppCommon.appBGUIColor))
        .navigationTitle("\(item.title)")
        .navigationBarTitleDisplayMode(.inline)
    }

}

// MARK: - Preview

#Preview {
    NavigationStack {
        DetailView(item: ListItemEntity(
            userId: 1,
            id: 1,
            title: "Sample Title",
            body: "This is a sample content that demonstrates how the detail view will display longer text. It should be scrollable and easy to read."
        ))
    }
}
