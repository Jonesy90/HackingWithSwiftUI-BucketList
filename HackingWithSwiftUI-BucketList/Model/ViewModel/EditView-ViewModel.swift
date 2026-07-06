//
//  EditView-ViewModel.swift
//  HackingWithSwiftUI-BucketList
//
//  Created by Michael Jones on 05/07/2026.
//

import Foundation

extension EditView {
    @Observable
    class ViewModel {
        enum LoadingState {
            case loading, loaded, failed
        }
        
        var location: Location
        var name = String()
        var description = String()
        var loadingState: LoadingState = .loading
        var pages = [Page]()
        
        init(location: Location) {
            name = location.name
            description = location.description
            self.location = location
        }
        
        func createNewLocation() -> Location {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            return newLocation
        }
    }
}
