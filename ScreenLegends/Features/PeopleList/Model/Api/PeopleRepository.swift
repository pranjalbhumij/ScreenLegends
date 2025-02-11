//
//  PeopleClient.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import Foundation
import Combine

class PeopleRepository {
    let restClient: RESTClient
    
    init(restClient: RESTClient) {
        self.restClient = restClient
    }
    
    func get(request: RESTRequest) -> AnyPublisher<PeopleListResponse, PeopleListError> {
        restClient.hit(restRequest: request)
            .mapError{ self.handleError($0) }
            .eraseToAnyPublisher()
    }
}

extension PeopleRepository {
    private func handleError(_ error: NetworkError) -> PeopleListError {
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

