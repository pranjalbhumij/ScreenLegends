//
//  ImageConfiguration.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import Foundation

struct Configuration: Codable {
    let baseURL: String
    let secureBaseURL: String
    let backdropSizes: [String]
    let logoSizes: [String]
    let posterSizes: [String]
    let profileSizes: [String]
    let stillSizes: [String]

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case secureBaseURL = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
}
