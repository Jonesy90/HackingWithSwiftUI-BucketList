//
//  Location.swift
//  HackingWithSwiftUI-BucketList
//
//  Created by Michael Jones on 01/07/2026.
//

import Foundation

/// A Struct for storing information about geographic locations.
struct Location: Codable, Equatable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    var latitude: Double
    var longitude: Double
}
