//
//  EditView.swift
//  HackingWithSwiftUI-BucketList
//
//  Created by Michael Jones on 01/07/2026.
//

import SwiftUI

struct EditView: View {
    @State private var viewModel: ViewModel
    
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    
    /// Lets the view display and edit the name and description of a location and ensures the fields are tracked with SwiftUI's reactive state system.
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section() {
                    TextField("Place Name", text: $viewModel.name)
                    TextField("Place Description", text: $viewModel.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text("\(Text(page.title).font(.headline)): \(Text(page.description).italic())")
                        }
                    case .failed:
                        Text("Please try again later...")
                    }
                }
            }
            .navigationTitle("Place Details")
            .task {
                await fetchNearbyPlaces()
            }
            .toolbar {
                Button("Save") {
                    let newLocation = viewModel.createNewLocation()
                    onSave(newLocation)
                    dismiss()
                }
            }
        }
    }
    
    /// Fetches nearby pages based on the geographic location (latitude and longitude). It updates the views state to reflect the progress and results of the network request.
    private func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(viewModel.location.latitude)%7C\(viewModel.location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL\(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            viewModel.pages = items.query.pages.values.sorted()
            viewModel.loadingState = .loaded
        } catch {
            viewModel.loadingState = .failed
        }
    }
}

#Preview {
    EditView(location: Location.example) { _ in }
}
