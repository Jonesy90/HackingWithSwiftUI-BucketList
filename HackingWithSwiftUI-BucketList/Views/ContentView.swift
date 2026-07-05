//
//  ContentView.swift
//  HackingWithSwiftUI-BucketList
//
//  Created by Michael Jones on 28/06/2026.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    
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
    
    var body: some View {
        if viewModel.isUnlocked {
            /// Creates an interactive map, allowing the user to see existing locations as markers and add new locations by tapping on the map.
            /// MapReader is a SwiftUI view that provides programmatic access to map-related actions and coordinate conversions.
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    ForEach(viewModel.locations) { location in
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
                                    viewModel.selectedPlace = location
                                }
                        }
                    }
                }
                /// The onTapGesture returns a CGPoint which is converted to CLLocationCoordinate2D from the current view.
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        viewModel.addLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace) { location in
                    EditView(location: location) {
                        viewModel.update(location: $0)
                    }
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
