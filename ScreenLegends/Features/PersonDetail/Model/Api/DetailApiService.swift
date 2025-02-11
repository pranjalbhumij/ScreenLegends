//
//  DetailClient.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 11/02/25.
//

import Foundation
import Combine

class DetailApiService {
    let restClient: RESTClient
    
    init(restClient: RESTClient) {
        self.restClient = restClient
    }
    
    func get(request: RESTRequest) -> AnyPublisher<PersonDetail, DetailError> {
        restClient.hit(restRequest: request)
            .mapError{ self.handleError($0) }
            .eraseToAnyPublisher()
    }
}

extension DetailApiService {
    private func handleError(_ error: NetworkError) -> DetailError {
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
