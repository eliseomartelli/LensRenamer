//
//  AddLensView.swift
//  LensRenamer
//
//  Created by Eliseo Martelli on 20/07/25.
//

import SwiftUI

/// A view for adding a new lens to the collection.
struct AddLensView: View {
    /// The view model managing lens data.
    @ObservedObject var viewModel: LensViewModel
    /// Controls the presentation of this view.
    @Binding var isPresented: Bool
    
    /// The lens to edit, if any.
    var lensToEdit: Lens?

    @State private var make: String = ""
    @State private var model: String = ""
    @State private var focalLength: String = ""
    @State private var serialNumber: String = ""
    @State private var showValidationError: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(lensToEdit == nil ? "Add New Lens" : "Edit Lens")
                .font(.title)
                .padding(.bottom, 8)

            Form {
                TextField("Make", text: $make)
                TextField("Model", text: $model)
                TextField("Focal Length (mm)", text: $focalLength)
                TextField("Serial Number", text: $serialNumber)
            }
            .formStyle(.grouped)

            if showValidationError {
                Text("Please enter a valid focal length.")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            HStack {
                Spacer()
                Button("Cancel") {
                    isPresented = false
                }
                Button(lensToEdit == nil ? "Save" : "Update") {
                    if let focal = Double(focalLength), !make.isEmpty, !model.isEmpty {
                        if let lens = lensToEdit {
                            viewModel.updateLens(lens: lens, make: make, model: model, focalLength: focal, serialNumber: serialNumber)
                        } else {
                            viewModel.addLens(lens: Lens(
                                focalLength: focal,
                                make: make,
                                model: model,
                                serialNumber: serialNumber)
                            )
                        }
                        isPresented = false
                    } else {
                        showValidationError = true
                    }
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(.top)
        }
        .padding()
        .frame(width: 340)
        .alert(isPresented: $showValidationError) {
            Alert(title: Text("Invalid Input"), message: Text("Please enter a valid focal length and fill all required fields."), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            if let lens = lensToEdit {
                make = lens.make
                model = lens.model
                focalLength = String(lens.focalLength)
                serialNumber = lens.serialNumber
            }
        }
    }
}

#Preview {
}
