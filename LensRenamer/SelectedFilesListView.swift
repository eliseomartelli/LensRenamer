//
//  SelectedFilesListView.swift
//  LensRenamer
//
//  Created by Eliseo Martelli on 21/07/25.
//

import SwiftUI

/// A view displaying the list of selected files.
struct SelectedFilesListView: View {
    let selectedFiles: [URL]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Working on:")
                .font(.headline)
            ScrollView {
                ForEach(selectedFiles, id: \.self) { url in
                    Text(url.lastPathComponent)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    SelectedFilesListView(selectedFiles: [
        URL(fileURLWithPath: "/Users/example/Pictures/photo1.jpg"),
        URL(fileURLWithPath: "/Users/example/Pictures/photo2.png"),
        URL(fileURLWithPath: "/Users/example/Pictures/photo3.tif")
    ])
    .padding()
    .frame(width: 300)
}
