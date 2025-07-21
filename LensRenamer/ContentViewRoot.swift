//
//  ContentViewRoot.swift
//  LensRenamer
//
//  Created by Eliseo Martelli on 21/07/25.
//

import SwiftUI
import SwiftData

/// Root view that injects the model context into the ContentView's view model.
struct ContentViewRoot: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ContentView(viewModel: LensViewModel(modelContext: modelContext))
    }
}

#Preview {
    ContentViewRoot()
}
