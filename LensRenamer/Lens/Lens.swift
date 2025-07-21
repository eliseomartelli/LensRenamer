//
//  Lens.swift
//  LensRenamer
//
//  Created by Eliseo Martelli on 20/07/25.
//

import Foundation
import SwiftData

/// A model representing a camera lens.
///
/// Each lens has a unique identifier (`id`), a serial number, make, model, and focal length.
/// The `id` is used for identification and should not be changed. The serial number can be edited.
@Model
class Lens: Identifiable, Hashable {
    /// The unique identifier for the lens.
    @Attribute(.unique) var id: UUID = UUID()

    /// The serial number of the lens. This can be edited.
    var serialNumber: String

    /// The manufacturer of the lens.
    var make: String

    /// The model name or number of the lens.
    var model: String

    /// The focal length of the lens in millimeters.
    var focalLength: Double
    
    /// Initializes a new lens.
    /// - Parameters:
    ///   - focalLength: The focal length of the lens.
    ///   - make: The manufacturer of the lens.
    ///   - model: The model name or number of the lens.
    ///   - serialNumber: The serial number of the lens.
    init(focalLength: Double, make: String, model: String, serialNumber: String) {
        self.focalLength = focalLength
        self.make = make
        self.model = model
        self.serialNumber = serialNumber
    }
}
