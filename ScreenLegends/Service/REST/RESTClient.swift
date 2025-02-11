import Foundation
import Combine

/// A networking client that handles REST API requests using Combine and URLSession.
class RESTClient {
    
    /// Initializes a new instance of `RESTClient`.
    public init() { }

    /// Sends an HTTP request and returns a publisher that emits a decoded response.
    /// - Parameter restRequest: The REST request containing the URL, method, headers, and body.
    /// - Returns: A publisher emitting a decoded response of type `T` or a `NetworkError`.
    func hit<T: Decodable>(restRequest: RESTRequest) -> AnyPublisher<T, NetworkError> {
        return Just(restRequest)
            .tryMap { try self.prepareURLRequest(from: $0) }
            .flatMap { request in
                URLSession.shared.dataTaskPublisher(for: request)
                    .mapError { self.handleError($0) }
                    .tryMap { data, response in
                        try self.handleResponse(response, data: data, urlRequest: request)
                        return data
                    }
                    .mapError { $0 as? NetworkError ?? .unknown(error: $0) }
            }
            .tryMap { data in
                try self.decodeResponse(data: data)
            }
            .mapError { $0 as? NetworkError ?? .unknown(error: $0) }
            .eraseToAnyPublisher()
    }

    private func prepareURLRequest(from request: RESTRequest) throws -> URLRequest {
        let completeURL: URL?

        if #available(iOS 16.0, macOS 13.0, *) {
            var url = request.baseURL.appending(path: request.endPoint)
            if let queryParams = request.queryParams {
                url = url.appending(queryItems: queryParams)
            }
            completeURL = url
        } else {
            let url = request.baseURL.appendingPathComponent(request.endPoint, isDirectory: false)
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            urlComponents?.queryItems = request.queryParams
            completeURL = urlComponents?.url
        }

        guard let completeURL else {
            throw NetworkError.badURL
        }

        var urlRequest = URLRequest(url: completeURL)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        do {
            if let body = request.body {
                urlRequest.httpBody = try JSONEncoder().encode(body)
            }
            return urlRequest
        } catch {
            throw NetworkError.bodyEncodingError(description: error.localizedDescription)
        }
    }
}

extension RESTClient {
    private func handleResponse(_ response: URLResponse, data: Data, urlRequest: URLRequest) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverUnreachable
        }
        if httpResponse.statusCode != 200 {
            logDetails(urlRequest: urlRequest, responseData: data, httpResponse: httpResponse)
            try handleHTTPResponseError(httpResponse)
        }
    }

    private func handleHTTPResponseError(_ httpResponse: HTTPURLResponse) throws {
        if 500...599 ~= httpResponse.statusCode {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        } else if httpResponse.statusCode == 429 {
            throw NetworkError.rateLimited
        } else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }

    private func decodeResponse<T: Decodable>(data: Data) throws -> T {
        do {
            if String.self == T.self {
                return String(decoding: data, as: UTF8.self) as! T
            } else {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                print(decodedData)
                return decodedData
            }
        } catch {
            print(error)
            do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Decoding failed for: \(json)")
                    } catch {
                        print("Also failed to decode as a generic.")
                    }
            throw NetworkError.responseDecodingError(description: error.localizedDescription)
        }
    }

    private func handleError(_ error: Error) -> NetworkError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return NetworkError.noInternetConnection
            case .timedOut:
                return NetworkError.timeout
            case .cannotFindHost, .cannotConnectToHost:
                return NetworkError.serverUnreachable
            default:
                return NetworkError.requestFailed(error: urlError)
            }
        }
        return NetworkError.requestFailed(error: error)
    }

    private func logDetails(urlRequest: URLRequest, responseData: Data, httpResponse: HTTPURLResponse) {
        print("URL: \(urlRequest.url?.absoluteString ?? "Unknown URL")")
        print("HTTP Method: \(urlRequest.httpMethod ?? "Unknown Method")")
        print("Status Code: \(httpResponse.statusCode)")
        if let requestBody = urlRequest.httpBody {
            let requestBodyString = String(data: requestBody, encoding: .utf8) ?? "Could not decode request body"
            print("Request Body: \(requestBodyString)")
        }
        let responseBody = String(data: responseData, encoding: .utf8) ?? "Could not decode response"
        print("Response Body: \(responseBody)")
    }
}

