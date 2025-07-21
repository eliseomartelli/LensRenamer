//
//  LensDetailViewModel.swift
//  LensRenamer
//
//  Created by Eliseo Martelli on 21/07/25.
//

import SwiftUI
import UniformTypeIdentifiers

/// ViewModel for LensDetailView, handles file selection and EXIF writing.
class LensDetailViewModel: ObservableObject {
    let lens: Lens

    @Published var selectedFiles: [URL] = []
    @Published var dropTargetHover = false
    @Published var processing = false

    init(lens: Lens) {
        self.lens = lens
    }

    /// Opens a file selection dialog for the user to select files.
    func selectFiles() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        if panel.runModal() == .OK {
            processFiles(urls: panel.urls)
        }
    }

    /// Handles files dropped onto the drop area.
    func handleDrop(providers: [NSItemProvider]) -> Bool {
        var urls: [URL] = []
        let group = DispatchGroup()

        for provider in providers {
            group.enter()
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) {
                item, error in
                defer { group.leave() }

                if let data = item as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil)
                {
                    urls.append(url)
                } else if let error = error {
                    print("Error loading dropped file URL: \(error)")
                }
            }
        }

        group.notify(queue: .main) {
            self.processFiles(urls: urls)
        }

        return true
    }

    /// Processes the selected or dropped files.
    func processFiles(urls: [URL]) {
        processing = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.writeExif(for: urls)
            DispatchQueue.main.async {
                self.processing = false
            }
        }
    }

    /// Writes EXIF data to a file using exiftool.
    private func writeExif(for files: [URL]) {
        guard let exiftoolURL = Bundle.main.url(forResource: "exiftool", withExtension: nil) else {
            print("Could not locate exiftool in bundle")
            return
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/perl")
        process.arguments = [
            exiftoolURL.path,
            "-overwrite_original",
            "-LensMake=\(lens.make)",
            "-LensModel=\(lens.make) \(lens.model)",
            "-FocalLength=\(lens.focalLength)",
            "-LensSerialNumber=\(lens.serialNumber)",
        ] + files.map { $0.path }

        if let libURL = Bundle.main.url(forResource: "lib", withExtension: nil) {
            process.environment = [
                "PERL5LIB": libURL.path
            ]
        } else {
            print("Warning: Could not locate 'lib' in bundle — PERL5LIB will not be set")
        }

        // Capture stdout and stderr for debugging:
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
            process.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                print("ExifTool output:\n\(output)")
            }
        } catch {
            print("Failed to run exiftool: \(error)")
        }
    }
}
