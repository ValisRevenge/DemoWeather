//
//  Client.swift
//  DemoWeather
//
//  Created by Mishko on 5/14/19.
//  Copyright © 2019 322org. All rights reserved.
//

import Foundation
import Alamofire

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

final class Client {
    
    private var baseUrl: String
    
    init(url: String) {
        baseUrl = url;
    }
    
    func load(path: String, httpMethod: RequestMethod, params: [String:Any], completion: @escaping(Any?, ServiceError) ->()) -> URLSessionDataTask? {
        return nil
    }
    
}
extension URL {
    init(baseUrl: String, path: String, params: [String:Any], method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        switch method {
        case .get:
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        default:
            break
        }
        
        self = components.url!
    }
}


