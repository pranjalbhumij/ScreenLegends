//
//  TMDBConfiguration.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import Foundation

struct TMDBConfiguration: Codable {
    let changeKeys: [String]
    let images: Configuration

    enum CodingKeys: String, CodingKey {
        case changeKeys = "change_keys"
        case images
    }
}
