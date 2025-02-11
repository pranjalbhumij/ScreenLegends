//
//  ModelData.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import Foundation

class ModelData {
    static var personList: PeopleListResponse = load("people_data.json")
    static var configuration: TMDBConfiguration = load("configuration_data.json")
}

func load<T: Decodable>(_ fileName: String) -> T {
    guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("Failed to load file")
    }
    
    do {
        let data = try Data(contentsOf: file)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    } catch {
        fatalError("Failed to decode data \(error)")
    }
}
