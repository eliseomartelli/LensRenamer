//
//  LensDetailView.swift
//  LensRenamer
//
//  Created by Eliseo Martelli on 20/07/25.
//

import SwiftUI
import SwiftData

/// A view displaying detailed information about a lens and allowing file processing.
struct LensDetailView: View {
    @StateObject var viewModel: LensDetailViewModel
    private var lensViewModel: LensViewModel
    
    @State private var isEditing = false
    private var lens: Lens

    init(lens: Lens, lensViewModel: LensViewModel) {
        self.lens = lens
        _viewModel = StateObject(wrappedValue: LensDetailViewModel(lens: lens))
        self.lensViewModel = lensViewModel
    }

    var body: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.width < 600
            VStack(alignment: .leading, spacing: 24) {
                if isCompact {
                    VStack(alignment: .leading, spacing: 24) {
                        LensInfoView(lens: viewModel.lens, processing: viewModel.processing)
                        FileSelectionView(
                            dropTargetHover: $viewModel.dropTargetHover,
                            selectFiles: viewModel.selectFiles,
                            handleDrop: viewModel.handleDrop
                        )
                    }
                } else {
                    HStack(alignment: .top, spacing: 24) {
                        LensInfoView(lens: viewModel.lens, processing: viewModel.processing)
                            .frame(maxWidth: .infinity)
                        FileSelectionView(
                            dropTargetHover: $viewModel.dropTargetHover,
                            selectFiles: viewModel.selectFiles,
                            handleDrop: viewModel.handleDrop
                        )
                    }
                }
                if !viewModel.selectedFiles.isEmpty {
                    SelectedFilesListView(selectedFiles: viewModel.selectedFiles)
                        .padding(.top, 8)
                }
            }
            .padding(32)
        }
        .toolbar {
            Button(action: {
                isEditing = true
            }) {
                Image(systemName: "pencil")
            }
        }
        .sheet(isPresented: $isEditing) {
            AddLensView(viewModel: lensViewModel, isPresented: $isEditing, lensToEdit: lens)
        }

    }
}

#Preview {
    let sampleLens = Lens(
        focalLength: 50.0,
        make: "Canon",
        model: "EF 50mm f/1.8",
        serialNumber: "12345ABC"
    )
    
    let container = try! ModelContainer(for: Lens.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    LensDetailView(lens: sampleLens, lensViewModel: LensViewModel(modelContext: container.mainContext))
}
