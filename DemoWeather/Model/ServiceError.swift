//
//  ServiceError.swift
//  DemoWeather
//
//  Created by Mishko on 5/13/19.
//  Copyright © 2019 322org. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case noInternetConnection
    case custom(String)
    case other
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No internet connection ("
        case .other:
            return "smth went wrong"
        case .custom(let message):
            return message
        }
    }
}
