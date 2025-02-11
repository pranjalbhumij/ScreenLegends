//
//  PeopleViewModel.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import Foundation
import Combine

/// Represents the different states of the People list.
enum PeopleViewState {
    case empty
    case loading
    case loaded
    case error(String)
}

/// A view model responsible for managing the list of people, handling API requests,
/// and updating the view state accordingly.
class PeopleViewModel: ObservableObject {
    let repository: PeopleRepository
    var cancellable = Set<AnyCancellable>()
    @Published var state: PeopleViewState = .loading
    var currentPage = 1
    var totalPages = 1
    var isLoading = false
    var people: [Person] = []
    
    /// Initializes the `PeopleViewModel` with a repository.
    /// - Parameter repository: The repository used to fetch people data.
    init(repository: PeopleRepository) {
        self.repository = repository
    }
    
    /// Fetches the list of people from the API.
    /// - Updates the `state` and `people` properties accordingly.
    /// - Prevents multiple simultaneous requests using `isLoading`.
    func get() {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        let request = PeopleRequest(page: currentPage.description)
        repository.get(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let failure) = completion {
                    self?.state = .error(failure.localizedDescription)
                }
            }, receiveValue: { [weak self] value in
                self?.state = .loaded
                self?.people.append(contentsOf: value.results)
                self?.totalPages = value.totalPages
            })
            .store(in: &cancellable)
    }
    
    func loadMore() {
        if canLoadMore() {
            currentPage += 1
            get()
        }
    }
    
    private func canLoadMore() -> Bool{
       return currentPage < totalPages
    }
}
