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
    @State var showUpdateAlert: Bool = false
    @StateObject private var versionViewModel = VersionViewModel()

    var body: some Scene {
        WindowGroup {
            ContentViewRoot()
                .frame(minWidth: 600, minHeight: 400)
                .onChange(of: versionViewModel.latestVersion) {
                    checkForUpdate()
                }
                .alert(isPresented: $showUpdateAlert, content: updateAlert)
        }
        .modelContainer(for: Lens.self)
    }
    
    private func checkForUpdate() {
        if Bundle.main.buildVersion! != versionViewModel.latestVersion {
            showUpdateAlert = true
        }
    }
    
    private let updateAlert: () -> Alert = {
        Alert(
            title: Text("LensRenamer is out of date"),
            message: Text("Please update LensRenamer to the latest version."),
            primaryButton: Alert.Button.default(
                Text("Open GitHub"),
                action: {
                    let url = URL(string: "https://github.com/eliseomartelli/LensRenamer/releases")!
                    NSWorkspace.shared.open(url)
                }),
            secondaryButton: Alert.Button.cancel(Text("Dismiss"))
        )
    }
}
