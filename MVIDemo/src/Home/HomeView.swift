//
//  HomeView.swift
//  MVIDemo
//
//  Created by ac_m1a on 11/02/2026.
//

import SwiftUI

// MARK: - HomeView

/// Home screen view following MVI architecture.
/// The View is a pure function of the container's state — it only reads state and sends intents.
/// All business logic lives in HomeContainer.
struct HomeView: View {
    
    // MARK: - Container
    
    /// MVI container that owns the state and processes intents
    @State private var container: HomeContainer
    
    // MARK: - Initialization
    
    init(container: HomeContainer = HomeContainer()) {
        _container = State(initialValue: container)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    switch container.state.phase {
                    case .loading:
                        // Loading phase: show nothing here, spinner is in overlay
                        Color.clear
                        
                    case .loaded:
                        if container.state.items.isEmpty {
                            // Loaded but no items — show empty state
                            emptyView
                        } else {
                            // Loaded with items — show list
                            listView
                        }
                        
                    case .error(let message):
                        // Error state — show error message with retry
                        errorView(message: message)
                    }
                }
            }
            .refreshable {
                // Send refresh intent — side effect will fetch and dispatch loadCompleted/loadFailed
                await withCheckedContinuation { continuation in
                    container.send(.refresh)
                    // Allow the refresh animation to complete after intent is sent
                    continuation.resume()
                }
            }
            .overlay {
                // Show spinner during loading phase
                if container.state.phase == .loading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.gray)
                }
            }
            .task {
                // Send initial load intent when the view first appears
                container.send(.initialLoad)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    // MARK: - View Components
    
    /// Empty state view — displayed when data loaded but result is empty
    private var emptyView: some View {
        EmptyView {
            Task {
                await NetworkPermissionService.shared.ensureNetworkPermission()
            }
        }
        .frame(maxWidth: .infinity)
        .containerRelativeFrame([.vertical])
    }
    
    /// Error state view with retry button
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                container.send(.initialLoad)
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
        .containerRelativeFrame([.vertical])
    }
    
    /// List content view — shows items when available
    private var listView: some View {
        ForEach(container.state.items) { item in
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
    HomeView(container: HomeContainer(service: ListFetchService()))
}

#Preview("Mock Service") {
    HomeView(container: HomeContainer(service: MockListFetchService()))
}
