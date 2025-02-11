//
//  ContentView.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import SwiftUI

/// - Displays a loading indicator until configuration is load ed.
/// - Initializes and injects dependencies into `PeopleListView`.
struct ContentView: View {
    @State private var isReady = false
    @State private var errorMessage: String?
    private let restClient: RESTClient
    @StateObject private var peopleViewModel: PeopleViewModel
    @StateObject private var searchViewModel: SearchViewModel

    /// Initializes ContentView with a REST client instance.
    /// - Parameter restClient: The shared REST client for network operations.
    init(restClient: RESTClient = RESTClient()) {
        self.restClient = restClient
        _peopleViewModel = StateObject(wrappedValue: PeopleViewModel(repository: PeopleRepository(restClient: restClient)))
        _searchViewModel = StateObject(wrappedValue: SearchViewModel(searchApi: SearchApiService(restClient: restClient)))
    }
    
    var body: some View {
        Group {
            if let error = errorMessage {
                ErrorView(errorDescription: error)
            } else if isReady {
                PeopleListView(
                    peopleViewModel: peopleViewModel,
                    searchViewModel: searchViewModel,
                    detailViewModelFactory: {
                        DetailViewModel(detailApi: DetailApiService(restClient: restClient))
                    }
                )
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            performNetworkRequest()
        }
    }

    /// Loads the app configuration before displaying the main content.
    /// - Updates `isReady` when the configuration is successfully retrieved.
    /// - Updates `errorMessage` when an error occurs.
    private func performNetworkRequest() {
        DispatchQueue.global().async {
                ConfigurationApi.shared.get() {
                    DispatchQueue.main.async {
                        self.isReady = true
                    }
                } onError: { error in
                    DispatchQueue.main.async {
                        self.errorMessage = error
                    }
                }
            }
        
    }
}

#Preview {
    ContentView()
}
