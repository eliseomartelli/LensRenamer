//
//  LensViewModel.swift
//  LensRenamer
//
//  Created by Eliseo Martelli on 20/07/25.
//

import Foundation
import SwiftData

class LensViewModel: ObservableObject {
    private var modelContext: ModelContext

    @Published var lenses: [Lens] = []
    @Published var errorMessage: String? = nil

    /// Initializes the view model with a given model context.
    /// - Parameter modelContext: The model context to use for data operations.
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        DispatchQueue.main.async {
            self.refresh()
        }
    }

    /// Refreshes the list of lenses from the model context.
    func refresh() {
        do {
            lenses = try modelContext.fetch(FetchDescriptor<Lens>())
        } catch {
            #if DEBUG
                print("Error fetching lenses: \(error)")
            #endif
            errorMessage = "Failed to load lenses: \(error.localizedDescription)"
        }
    }

    /// Adds a new lens to the model context and refreshes the list.
    /// - Parameter lens: The lens to add.
    func addLens(lens: Lens) {
        modelContext.insert(lens)
        DispatchQueue.main.async {
            self.refresh()
        }
    }

    /// Deletes a lens from the model context and refreshes the list.
    /// - Parameter lens: The lens to delete.
    func deleteLens(lens: Lens) {
        modelContext.delete(lens)
        DispatchQueue.main.async {
            self.refresh()
        }
    }
    
    func updateLens(lens: Lens, make: String, model: String, focalLength: Double, serialNumber: String) {
        lens.make = make
        lens.model = model
        lens.focalLength = focalLength
        lens.serialNumber = serialNumber
        DispatchQueue.main.async {
            self.refresh()
        }
    }
}
