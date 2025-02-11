//
//  DetailViewModel.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 11/02/25.
//

import Foundation
import Combine

enum DetailState {
    case error(String)
    case empty
    case loading
    case loaded(PersonDetail)
}

class DetailViewModel: ObservableObject {
    @Published var detailState: DetailState = .loading
    var cancellable = Set<AnyCancellable>()
    let detailApi: DetailApiService
    
    init(detailApi: DetailApiService) {
        self.detailApi = detailApi
    }
    
    func get(id: Int) {
        let request = DetailRequest(id: id.description)
        detailApi.get(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let failure) = completion {
                    self?.detailState = .error(failure.localizedDescription)
                }
            }, receiveValue: { [weak self] value in
                self?.detailState = .loaded(value)
            })
            .store(in: &cancellable
            )
    }
    
}
