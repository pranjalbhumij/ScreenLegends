//
//  PersonImageRequest.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import Foundation

class PersonImageRequest: RESTRequest {
    var endPoint: String = "/person/{person_id}/images"
    
    var httpMethod: HTTPMethod = .get
    
    var baseURL: URL = URL(string: ConfigProvider.shared.baseURL)!
    
    var headers: [String : String] = ["Authorization" : ConfigProvider.shared.apiKey]
    
}
