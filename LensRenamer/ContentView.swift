//
//  ContentView.swift
//  LensRenamer
//
//  Created by Eliseo Martelli on 20/07/25.
//

import SwiftData
import SwiftUI

/// The main content view displaying the user's lens collection.
struct ContentView: View {
    @ObservedObject private var viewModel: LensViewModel
    
    @State private var showAddSheet = false
    @State private var showErrorAlert = false
    @State private var selectedLensID: UUID?
    
    
    /// Initializes the content view with a LensViewModel.
    /// - Parameter viewModel: The view model to use for managing lenses.
    init(viewModel: LensViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .sheet(isPresented: $showAddSheet) {
                AddLensView(viewModel: viewModel, isPresented: $showAddSheet)
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK")) {
                        viewModel.errorMessage = nil
                    }
                )
            }
            .onReceive(viewModel.$errorMessage) { error in
                showErrorAlert = error != nil
            }
    }
    
    
    @ViewBuilder
    private var content: some View {
        if viewModel.lenses.isEmpty {
            EmptyLensesView(showAddSheet: $showAddSheet)
        } else {
            NavigationSplitView {
                List(viewModel.lenses, id: \.id, selection: $selectedLensID) { lens in
                    Text("\(lens.make) \(lens.model)")
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteLens(lens: lens)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                }
                .toolbar {
                    ToolbarItem {
                        Button(action: { showAddSheet = true }) {
                            Label("Add Lens", systemImage: "plus")
                        }
                    }
                }
                .navigationTitle("My Lenses")
            } detail: {
                if let selectedID = selectedLensID,
                   let lens = viewModel.lenses.first(where: { $0.id == selectedID }) {
                    LensDetailView(lens: lens, lensViewModel: viewModel)
                        .id(selectedID)
                } else {
                    NoLensSelectedView()
                }
            }
        }
    }
    
    private struct EmptyLensesView: View {
        @Binding var showAddSheet: Bool
        
        var body: some View {
            VStack(spacing: 16) {
                Image(systemName: "camera.metering.spot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray.opacity(0.5))
                Text("No Lenses Added")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Button(action: { showAddSheet = true }) {
                    Label("Add Your First Lens", systemImage: "plus.circle.fill")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
    
    private struct NoLensSelectedView: View {
        var body: some View {
            VStack(spacing: 16) {
                Image(systemName: "rectangle.dashed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray.opacity(0.5))
                Text("No Lens Selected")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Text("Select a lens from the list to view details.")
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Lens.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    // For preview, inject a mock or preview model context
    ContentView(viewModel: LensViewModel(modelContext: container.mainContext))
}
