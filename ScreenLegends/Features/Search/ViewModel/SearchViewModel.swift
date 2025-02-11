//
//  SearchViewModel.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 11/02/25.
//

import Foundation
import Combine

enum SearchState{
    case empty
    case loaded
    case loading
    case error(String)
}

class SearchViewModel: ObservableObject {
    @Published var state: SearchState = .loading
    var currentPage = 1
    var totalPages = 1
    var isLoading = false
    var people: [Person] = []
    var cancellable = Set<AnyCancellable>()
    let searchApi: SearchApiService
    
    init(searchApi: SearchApiService) {
        self.searchApi = searchApi
    }
    
    func search(query: String) {
        people.removeAll()
        continueSearch(query: query)
    }
    
    func continueSearch(query: String) {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        let request = SearchRequest()
        request.queryParams!.append(URLQueryItem(name: "page", value: currentPage.description))
        request.queryParams!.append(URLQueryItem(name: "query", value: query))
        searchApi.get(request: request)
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
    
    func loadMore(query: String) {
        if canLoadMore() {
            currentPage += 1
            continueSearch(query: query)
        }
    }
    
    private func canLoadMore() -> Bool{
        if currentPage < totalPages {
            return true
        }
        return false
    }
}
