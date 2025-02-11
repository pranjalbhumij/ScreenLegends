//
//  RESTRequest.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol RESTRequest {
    
    var endPoint: String { get }
    
    var body: Encodable? { get }
    
    var headers: [String: String] { get }
    
    var httpMethod: HTTPMethod { get }
    
    var baseURL: URL { get }
    
    var queryParams: [URLQueryItem]? { get }
}

public extension RESTRequest {
    
    var body: Encodable? { nil }
    
    var queryParams: [URLQueryItem]? { nil }
    
}
