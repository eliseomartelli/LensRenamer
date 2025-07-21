//
//  LensInfoView.swift
//  LensRenamer
//
//  Created by Eliseo Martelli on 21/07/25.
//

import SwiftUI

/// Displays lens information and a progress indicator if processing.
struct LensInfoView: View {
    let lens: Lens
    let processing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(lens.make) \(lens.model)")
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(1)
            HStack {
                Image(systemName: "camera.metering.spot")
                    .frame(width: 24, height: 24)
                Text("Focal Length")
                Text("\(lens.focalLength, specifier: "%.1f") mm")
                    .fontWeight(.medium)
            }
            HStack {
                Image(systemName: "number")
                    .frame(width: 24, height: 24)
                Text("Serial")
                Text(lens.serialNumber)
                    .fontWeight(.medium)
            }
            if processing {
                ProgressView()
            }
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
    
    LensInfoView(lens: sampleLens, processing: false)
}
