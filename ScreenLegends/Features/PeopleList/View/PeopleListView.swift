//
//  PeopleListView.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import SwiftUI

/// A SwiftUI view that displays a list of people along with search functionality.
///
/// - Supports lazy loading of people and search results.
/// - Integrates with `PeopleViewModel` and `SearchViewModel` for data fetching.
/// - Navigates to `DetailView` when a person is selected.
struct PeopleListView: View {
    @StateObject var peopleViewModel: PeopleViewModel
    @StateObject var searchViewModel: SearchViewModel
    let detailViewModelFactory: () -> DetailViewModel
    @State private var searchText = ""
    
    /// Initializes the `PeopleListView` with the required view models and detail view model factory.
    ///
    /// - Parameters:
    ///   - peopleViewModel: The view model responsible for managing the list of people.
    ///   - searchViewModel: The view model responsible for handling search functionality.
    ///   - detailViewModelFactory: A closure that creates an instance of `DetailViewModel`.
    init(peopleViewModel: PeopleViewModel, searchViewModel: SearchViewModel, detailViewModelFactory: @escaping () -> DetailViewModel) {
            _peopleViewModel = StateObject(wrappedValue: peopleViewModel)
            _searchViewModel = StateObject(wrappedValue: searchViewModel)
            self.detailViewModelFactory = detailViewModelFactory
        }
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        contentView
            .onAppear {
                peopleViewModel.state = .loading
                peopleViewModel.get()
            }
    }
    
    /// The main content view containing navigation and list views.
    @ViewBuilder
    private var contentView: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea(edges: .top)
                VStack {
                    searchView
                    if searchText.isEmpty {
                        peopleListView
                    } else {
                        searchResultsView
                    }
                }
                .navigationTitle(searchText.isEmpty ? "Popular" : "Search Results")
            }
        }
    }
    
    /// The list view displaying people.
    @ViewBuilder
    private var peopleListView: some View {
        switch peopleViewModel.state {
        case .empty:
            EmptyView()
        case .loading:
            loadingView
        case .loaded:
            listView
        case .error(let error):
            ErrorView(errorDescription: error)
        }
    }
    
    /// The list view displaying search results.
    @ViewBuilder
    private var searchResultsView: some View {
        switch searchViewModel.state {
        case .empty:
            EmptyView()
        case .loading:
            loadingView
        case .loaded:
            searchResultsListView
        case .error(let error):
            ErrorView(errorDescription: error)
        }
    }
    
    /// A scrollable grid displaying search results.
    private var searchResultsListView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(searchViewModel.people) { person in
                    NavigationLink(destination: DetailView(personId: person.id, knownFor: person.knownFor, viewModel: detailViewModelFactory())) {
                        PersonView(person: person)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    if person.id == peopleViewModel.people.last?.id {
                                        peopleViewModel.loadMore()
                                    }
                                }
                            }
                    }
                }
            }
            .padding()
        }
    }

    /// A scrollable grid displaying people.
    private var listView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(peopleViewModel.people) { person in
                    NavigationLink(destination: DetailView(personId: person.id, knownFor: person.knownFor, viewModel: detailViewModelFactory())) {
                        PersonView(person: person)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    if person.id == peopleViewModel.people.last?.id {
                                        peopleViewModel.loadMore()
                                    }
                                }
                            }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Popular")
    }
    
    /// The search bar allowing users to enter search queries.
    private var searchView: some View {
        TextField("Search People", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onChange(of: searchText) { newValue in
                if newValue.isEmpty {
                    peopleViewModel.get()
                } else {
                    searchViewModel.search(query: searchText)
                }
            }
    }
    
    /// A progress indicator displayed during loading states.
    private var loadingView: some View {
        ProgressView()
            .padding()
    }

}


//#Preview {
//    PeopleListView()
//}
