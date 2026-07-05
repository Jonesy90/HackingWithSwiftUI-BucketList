//
//  ContentView-ViewModel.swift
//  HackingWithSwiftUI-BucketList
//
//  Created by Michael Jones on 03/07/2026.
//

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit

/// Defines a class for the SwiftUI ContentView. The ViewModel manages a list of location objects, allowing users to update, add, and persist locations (in the documentsDirectory).
extension ContentView {
    @Observable
    class ViewModel {
        /// The array of locations [Location] is a read-only outside the class but it can be modified within the class.
        private(set) var locations: [Location]
        /// Holds a reference to a currently selected Location. Used for details or edits.
        var selectedPlace: Location?
        /// The file location of where the data about locations will be stored on disk.
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        var isUnlocked = false
        
        /// As soon as the ViewModel is created, it tries to load previous saved data from disk. If no data is available, it will start with an empty array.
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        /// Encodes the locations array into JSON and writes it to disk for persistence..
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        /// Creates a new Location instance at the provided coordinates.
        func addLocation(at point: CLLocationCoordinate2D) {
            /// The CLLocationCoordinate2D latitude and longitude are then appended to the locations array.
            let newLocation = Location(
                id: UUID(),
                name: "New Location",
                description: "",
                latitude: point.latitude,
                longitude: point.longitude
            )
            
            locations.append(newLocation)
            save()
        }
        
        /// Updates an existing location, replacing the selected place with an update version.
        func update(location: Location) {
            guard let selectedPlace else { return }
            
            /// Tries to find the position (index) of the location object within the locations array.
            /// Using the 'firstIndex(of: )' method searches for the first element in the array that is equal to location. If it finds one, it returns its position as an Int.
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        // error
                    }
                }
            } else {
                // no biometrics
            }
        }
    }
}
