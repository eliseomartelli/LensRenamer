//
//  FileSelectionView.swift
//  LensRenamer
//
//  Created by Eliseo Martelli on 21/07/25.
//

import SwiftUI
import UniformTypeIdentifiers

/// A view for selecting or dragging files.
struct FileSelectionView: View {
    @Binding var dropTargetHover: Bool
    var selectFiles: () -> Void
    var handleDrop: ([NSItemProvider]) -> Bool

    var body: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.width > 400
            if isCompact {
                HStack(spacing: 12) {
                    Button(action: selectFiles) {
                        Label("Select Files", systemImage: "folder")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .cornerRadius(8)
                    }
                    Text("or")
                        .foregroundColor(.secondary)
                    Text(dropTargetHover ? "Drop files here" : "Drag files here")
                        .frame(maxWidth: 200, minHeight: 80)
                        .background(
                            dropTargetHover
                                ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.08)
                        )
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    dropTargetHover ? Color.accentColor : Color.gray.opacity(0.2),
                                    lineWidth: 2)
                        )
                        .onDrop(of: [.fileURL], isTargeted: $dropTargetHover, perform: handleDrop)
                }
            } else {
                VStack(spacing: 12) {
                    Button(action: selectFiles) {
                        Label("Select Files", systemImage: "folder")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .cornerRadius(8)
                    }
                    Text("or")
                        .foregroundColor(.secondary)
                    Text(dropTargetHover ? "Drop files here" : "Drag files here")
                        .frame(maxWidth: 200, minHeight: 80)
                        .background(
                            dropTargetHover
                                ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.08)
                        )
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    dropTargetHover ? Color.accentColor : Color.gray.opacity(0.2),
                                    lineWidth: 2)
                        )
                        .onDrop(of: [.fileURL], isTargeted: $dropTargetHover, perform: handleDrop)
                }
            }
        }
    }
}
