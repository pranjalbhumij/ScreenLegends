//
//  ConfiguraitonClient.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import Foundation
import Combine

class ConfigurationApi {
    let request: ConfigurationRequest
    let restClient: RESTClient
    var cancellable = Set<AnyCancellable>()
    static let shared = ConfigurationApi(request: ConfigurationRequest(), restClient: RESTClient())
    var configuration: Configuration?
    
    
    private init(request: ConfigurationRequest, restClient: RESTClient) {
        self.request = request
        self.restClient = restClient
    }
    
    /// Fetches configuration data from the API.
    /// - Parameters:
    ///   - ready: Callback executed when the configuration is successfully loaded.
    ///   - onError: Callback executed when an error occurs.
    func get(ready: @escaping () -> Void, onError: @escaping (_ error: String) -> Void) {
        let publisher: AnyPublisher<TMDBConfiguration, NetworkError> =
            restClient.hit(restRequest: ConfigurationRequest())

        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    onError(ConfigurationError.unknownError.localizedDescription)
                }
            }, receiveValue: { [weak self]value in
                self?.configuration = value.images
                ready()
            })
            .store(in: &cancellable)
    }

}
