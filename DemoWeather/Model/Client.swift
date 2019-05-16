//
//  Client.swift
//  DemoWeather
//
//  Created by Mishko on 5/14/19.
//  Copyright © 2019 322org. All rights reserved.
//

import Foundation
import Reachability

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

final class WebClient {
    
    private var baseUrl: String
    
    init(url: String) {
        baseUrl = url;
    }
    
    func load(path: String, httpMethod: RequestMethod, params: [String:Any], completion: @escaping(Any?, ServiceError?) ->()) -> URLSessionDataTask? {
        let reach = Reachability()
        if !reach.isReachable() {
            completion(nil, .noInternetConnection)
            return nil
        }
        
        let request = URLRequest(baseUrl: baseUrl, path: path, method: httpMethod, params: params)
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            var object: Any? = nil
            if let data = data {
                object = try? JSONSerialization.data(withJSONObject: data, options: [])
            }
            
            if let httpResponce = responce as? HTTPURLResponse, (200..<300) ~= httpResponce.statusCode {
                completion(object, nil)
            }
            else {
                let error = (object as? [String:Any]).flatMap(ServiceError.init) ?? ServiceError.other
                completion(nil, error)
            }
            
        }
        task.resume()
        
        return task
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

extension URLRequest {
    init(baseUrl: String, path: String, method: RequestMethod, params:[String:Any]) {
        let url = URL(baseUrl: baseUrl, path: path, params: params, method: method)
        self.init(url: url)
        httpMethod = method.rawValue
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch method {
        case .post, .put:
            httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        default:
            break
        }
    }
}


