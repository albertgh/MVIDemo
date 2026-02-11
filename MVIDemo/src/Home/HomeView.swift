//
//  HomeView.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import SwiftUI

/// Home screen view displaying a list of items
/// Shows EmptyView when no data, can be pulled down to refresh
/// After fetch, displays list content
struct HomeView: View {
    
    // MARK: - ViewModel
    
    @State private var viewModel: HomeViewModel
    
    // MARK: - Initialization
    
    //init(viewModel: HomeViewModel = HomeViewModel(service: MockListFetchService())) {
    init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if viewModel.isLoading {
                        // loading
                    } else if viewModel.items.isEmpty {
                        emptyView
                    } else {
                        listView
                    }
                }
            }
            .refreshable {
                await viewModel.fetchData()
                viewModel.endRefresh()
                viewModel.applyPendingItems()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.gray)
                }
            }
            .task {
                await viewModel.initialLoad()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    // MARK: - View Components
    
    /// Empty state view - part of scrollable content, fills entire screen
    private var emptyView: some View {
        EmptyView {
            // Trigger network permission check when empty view appears
            // This will cause iOS to show the system network permission alert if not already granted
            Task {
                await NetworkPermissionService.shared.ensureNetworkPermission()
            }
        }
        .frame(maxWidth: .infinity)
        .containerRelativeFrame([.vertical])
    }
    
    /// List content view - shows items when available
    private var listView: some View {
        ForEach(viewModel.items) { item in
            NavigationLink(destination: DetailView(item: item)) {
                rowView(for: item)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Adapter
    
    /// Adapter: maps a ListItemEntity to a SwiftUI row view
    @ViewBuilder
    private func rowView(for item: ListItemEntity) -> some View {
        ListCell(
            id: item.id,
            title: item.title,
            subtitle: item.body
        )
    }
}

// MARK: - Previews

#Preview("Production Service") {
    HomeView(viewModel: HomeViewModel(service: ListFetchService()))
}

#Preview("Mock Service") {
    HomeView(viewModel: HomeViewModel(service: MockListFetchService()))
}
