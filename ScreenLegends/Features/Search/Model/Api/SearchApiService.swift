//
//  SearchClient.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 11/02/25.
//

import Foundation
import Combine

class SearchApiService {
    let restClient: RESTClient
    
    init(restClient: RESTClient) {
        self.restClient = restClient
    }
    
    func get(request: RESTRequest) -> AnyPublisher<PeopleListResponse, SearchError> {
        restClient.hit(restRequest: request)
            .mapError{ self.handleError($0) }
            .eraseToAnyPublisher()
    }
}

extension SearchApiService {
    private func handleError(_ error: NetworkError) -> SearchError {
        switch error {
            case .badURL, .serverUnreachable:
                return .dataNotFound
            case .timeout, .rateLimited, .serverError:
                return .unknownError
            default:
                return .unknownError
        }
    }
}
