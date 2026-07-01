//
//  Location.swift
//  HackingWithSwiftUI-BucketList
//
//  Created by Michael Jones on 01/07/2026.
//

import MapKit
import Foundation

/// A Struct for storing information about geographic locations.
struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    #if DEBUG
    /// This section will not get compiled into the release build.
    static let example = Location(id: UUID(), name: "Camberley", description: "", latitude: 51.33705, longitude: -0.74261)
    #endif
    
    
}
