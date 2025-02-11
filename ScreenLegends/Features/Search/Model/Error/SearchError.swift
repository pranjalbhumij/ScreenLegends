//
//  SearchError.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 11/02/25.
//

import Foundation

enum SearchError: LocalizedError {
    case dataNotFound
    case unknownError
}

extension SearchError {
    public var errorDescription: String? {
            switch self {
            case .dataNotFound:
                return "No data found"
            case .unknownError:
                return "Something went wrong"
            }
        }
}
