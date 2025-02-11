//
//  ConfigurationError.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 11/02/25.
//

import Foundation

enum ConfigurationError: LocalizedError {
    case unknownError
}

extension ConfigurationError {
    public var errorDescription: String? {
            switch self {
            case .unknownError:
                return "Something went wrong"
            }
        }
}
