//
//  ListItemEntity.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import Foundation

/// Entity model representing a list item from the API
struct ListItemEntity: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let subtitle: String
    let content: String
}

