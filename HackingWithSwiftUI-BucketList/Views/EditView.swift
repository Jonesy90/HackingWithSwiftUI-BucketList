//
//  EditView.swift
//  HackingWithSwiftUI-BucketList
//
//  Created by Michael Jones on 01/07/2026.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    
    var location: Location
    
    @State private var name: String
    @State private var description: String
    
    var onSave: (Location) -> Void
    
    /// Lets the view display and edit the name and description of a location and ensures the fields are tracked with SwiftUI's reactive state system.
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        /// Sets up the state variable name (@State property) with an initial value taken from location.name or location.description.
        /// The underscore (_name) access the property wrapper storage directly, which is the correct way to initialise @State properties inside a custom initialiser.
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section() {
                    TextField("Place Name", text: $name)
                    TextField("Place Description", text: $description)
                }
            }
            .navigationTitle("Place Details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation)
                    
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    EditView(location: Location.example) { _ in }
}
