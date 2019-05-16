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

extension ServiceError {
    init(json: [String:Any]) {
        if let message = json["message"] as? String {
            self = .custom(message)
        }
        else {
            self = .other
        }
    }
}
