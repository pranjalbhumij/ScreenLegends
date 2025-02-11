//
//  ConfigProvider.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 11/02/25.
//

import Foundation

final class ConfigProvider {
    static let shared = ConfigProvider()
    
    private init() {}
    
    var baseURL: String {
        return Bundle.main.infoDictionary? ["BASE_URL"] as! String
    }
    
    var apiKey: String {
        return Bundle.main.infoDictionary? ["API_KEY"] as! String
    }
}
