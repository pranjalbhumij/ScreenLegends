//
//  PersonResponse.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import Foundation

struct Person: Codable, Identifiable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String?
    let name: String
    let originalName: String?
    let popularity: Double
    let profilePath: String?
    let knownFor: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id, popularity, name
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
}
