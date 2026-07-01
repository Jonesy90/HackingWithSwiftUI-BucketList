//
//  Result.swift
//  HackingWithSwiftUI-BucketList
//
//  Created by Michael Jones on 01/07/2026.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
}
