//
//  ContentView.swift
//  HackingWithSwiftUI-BucketList
//
//  Created by Michael Jones on 28/06/2026.
//

import MapKit
import SwiftUI

struct ContentView: View {
    /// Defines the initial camera position for a map view, which determines what part of the world is visible when the map first appears.
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            /// Creates a coordinate object for the center of the map.
            center: CLLocationCoordinate2D(
                latitude: 56,
                longitude: -3
            ),
            /// Sets how much of the map is visible (the zoom level).
            span: MKCoordinateSpan(
                latitudeDelta: 10,
                longitudeDelta: 10
            )
        )
    )
    
    @State private var locations = [Location]()
    @State private var selectedPlace: Location?
    
    var body: some View {
        /// Creates an interactive map, allowing the user to see existing locations as markers and add new locations by tapping on the map.
        /// MapReader is a SwiftUI view that provides programmatic access to map-related actions and coordinate conversions.
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                ForEach(locations) { location in
                    /// Annotation is a view used in MapKit to display custom markers (map annotations).
                    Annotation(
                        location.name,
                        coordinate: location.coordinate
                    ) {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundStyle(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(.circle)
                            .onLongPressGesture(minimumDuration: 0.1){
                                selectedPlace = location
                            }
                    }
                }
            }
            /// The onTapGesture returns a CGPoint which is converted to CLLocationCoordinate2D from the current view.
            /// The CLLocationCoordinate2D latitude and longitude are then appended to the locations array.
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    let newLocation = Location(
                        id: UUID(),
                        name: "New Location",
                        description: "",
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    )
                    
                    locations.append(newLocation)
                }
            }
            .sheet(item: $selectedPlace) { location in
                EditView(location: location) { newLocation in
                    /// Tries to find the position (index) of the location object within the locations array.
                    /// Using the 'firstIndex(of: )' method searches for the first element in the array that is equal to location. If it finds one, it returns its position as an Int.
                    if let index = locations.firstIndex(of: location) {
                        locations[index] = newLocation
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
