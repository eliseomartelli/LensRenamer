//
//  LensRenamerApp.swift
//  LensRenamer
//
//  Created by Eliseo Martelli on 20/07/25.
//

import SwiftUI
import SwiftData

@main
struct LensRenamerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentViewRoot()
                .frame(minWidth: 600, minHeight: 400)
        }
        .modelContainer(for: Lens.self)
    }
}
