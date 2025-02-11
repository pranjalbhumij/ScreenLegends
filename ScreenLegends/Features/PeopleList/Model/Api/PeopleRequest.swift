//
//  PeopleRequest.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import Foundation

class PeopleRequest: RESTRequest {
    var endPoint: String = "/person/popular"
    
    var httpMethod: HTTPMethod = .get
    
    var baseURL: URL = URL(string: ConfigProvider.shared.baseURL)!
    
    var headers: [String : String] = ["Authorization" : ConfigProvider.shared.apiKey]
    
    var queryParams: [URLQueryItem]? = [
        URLQueryItem(name: "language", value: "en-US")
      ]
    
    init(page: String) {
        self.queryParams!.append(URLQueryItem(name: "page", value: page))
    }
}
