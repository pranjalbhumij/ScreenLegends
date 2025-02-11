//
//  PeopleListError.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 11/02/25.
//

import Foundation

enum PeopleListError: LocalizedError {
    case dataNotFound
    case unknownError
}

extension PeopleListError {
    public var errorDescription: String? {
            switch self {
            case .dataNotFound:
                return "No data found"
            case .unknownError:
                return "Something went wrong"
            }
        }
}

