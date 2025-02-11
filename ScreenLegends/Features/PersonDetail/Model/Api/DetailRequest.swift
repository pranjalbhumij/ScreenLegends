//
//  DetailRequest.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import Foundation

class DetailRequest: RESTRequest {
    var endPoint: String
    
    var httpMethod: HTTPMethod = .get
    
    var baseURL: URL = URL(string: ConfigProvider.shared.baseURL)!
    
    var headers: [String : String] = ["Authorization" : ConfigProvider.shared.apiKey]
    
    var queryParams: [URLQueryItem] = [
        URLQueryItem(name: "language", value: "en-US")
    ]
    
    init(id: String) {
        self.endPoint = "/person/\(id)" 
    }
}
